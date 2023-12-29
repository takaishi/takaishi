import { program } from 'commander';
import { Octokit } from "@octokit/rest";
import { RestEndpointMethodTypes } from '@octokit/plugin-rest-endpoint-methods';
import OpenAI from 'openai';

type Options = {
    user: string;
    periodStart: string;
    periodEnd: string;
    orgs: string[];
    repositories: string[];
    excludeRepositories: string[];
};

const fetchPullRequests = async (options: Options) => {
    const octokit = new Octokit({
        auth: process.env.GITHUB_TOKEN,
        paginate: 'auto',
    });
    const orgs = options.orgs.map(repo => `org:${repo}`).join(' ');
    const excludeRepos = options.excludeRepositories.map(repo => `-repo:${repo}`).join(' ');
    const q = `author:${options.user} created:${options.periodStart}..${options.periodEnd} ${orgs} ${excludeRepos} type:pr`
    const pullRequests = await octokit.paginate(octokit.search.issuesAndPullRequests, { q });

    return pullRequests.filter(pr => !options.excludeRepositories.includes(pr.repository_url.split('/').slice(-1)[0]));
};

program.option(`--summarize`, 'summarize by OpenAI', false);
program.option('--orgs <orgs>', 'Organizations', (value, previous) => previous.concat([value]), []);
program.option('--username <username>', 'Username', (value, previous) => previous.concat([value]), []);
program.option('--repos <repos>', 'Include repositories', (value, previous) => previous.concat([value]), []);
program.option('--exclude-repos <repos>', 'Exclude repositories', (value, previous) => previous.concat([value]), []);
program.option('--start <start>', 'start date (YYYY-MM-DD)', (value, previous) => previous.concat([value]), []);
program.option('--end <end>', 'end date (YYYY-MM-DD)', (value, previous) => previous.concat([value]), []);

program.parse(process.argv);

const options: Options = {
    user: program.opts().username, // Replace with the GitHub username
    periodStart: program.opts().start,
    periodEnd: program.opts().end,
    orgs: program.opts().orgs || [],
    repositories: program.opts().repositories || [],
    excludeRepositories: program.opts().exclude_repositories || [],
};


(async () => {
    const prs = await fetchPullRequests(options) as unknown as RestEndpointMethodTypes["search"]["issuesAndPullRequests"]["response"]["data"]["items"];

    const sortedPrs = prs.sort((a, b) => (
        a.created_at.localeCompare(b.created_at) || a.repository_url.localeCompare(b.repository_url)
    ));

    const categorizedPrs: { [key: string]: { [key: string]: typeof prs } } = {};

    // Group PRs by month and repository
    sortedPrs.forEach((pr) => {
        const month = pr.created_at.split('T')[0].slice(0, 7);
        const repo = pr.repository_url.split('/').slice(-2).join('/');

        // initialize with empty object if undefined
        if (!categorizedPrs[month]) categorizedPrs[month] = {};

        if (!categorizedPrs[month][repo]) categorizedPrs[month][repo] = [];

        categorizedPrs[month][repo].push(pr);
    });

    if (program.opts().summarize) {

        let output = [];
        Object.keys(categorizedPrs).sort().forEach((month) => {
            let o = '';
            o += `## ${month}\n`;

            Object.keys(categorizedPrs[month]).sort().forEach(repo => {
                o += `### ${repo}\n`;

                categorizedPrs[month][repo].forEach((pr) => {
                    o += `- ${pr.title}\n`;
                });
                o += '\n';
            });
            output.push(o);

        });

        for (let i = 0; i < output.length; i++) {
            const openai = new OpenAI();
            openai.apiKey = process.env.OPENAI_API_KEY
            const systemPrompt = `
              以下のフォーマットで与える月毎のPullRequest一覧について、以下の条件でサマライズしてください。
              
              - 日本語で出力してください
              - 能動態で記述してください
              - サマライズ結果はリポジトリ毎に最大5つのトピックとし、価値の高そうなものを優先して記述してください
              
              Input format:

              ## YYYY-MM
              ### {repository_name}
                - {pull request 001 title}
                - {pull request 002 title}
              
              Output format:
              
              ## YYYY-MM
              ### {repository_name}
              
              - {topic 1}
              - {topic 2}
            `;

            const apiResponse = await openai.chat.completions.create({
                model: 'gpt-4',
                messages: [
                    {"role": "system", "content": systemPrompt},
                    {"role": "user", "content": output[i]},
                ],
            });

            console.log(apiResponse.choices[0].message.content + "\n");
        }
    } else {
        Object.keys(categorizedPrs).sort().forEach((month) => {
            console.log(`## ${month}`);

            Object.keys(categorizedPrs[month]).sort().forEach(repo => {
                console.log(`### ${repo}`);

                categorizedPrs[month][repo].forEach((pr) => {
                    console.log(`- ${pr.title} ${pr.html_url}`);
                });
                console.log('\n');
            });
        });
    }
})();

