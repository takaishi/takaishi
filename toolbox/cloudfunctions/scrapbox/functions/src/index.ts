import * as functions from "firebase-functions";
import * as dayjs from "dayjs";
import "dayjs/locale/ja"; // これimportしないとエラー吐かれる
import fetch from "node-fetch";

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const index = functions.region('asia-northeast1').https.onRequest(async (request, response) => {
  const d = request.query.date
  if (d == undefined || d == '') {
    const today = new Date();
    const yearMonthDay = dayjs(today).locale("ja").format("YYYY-MM-DD");
    response.send(await run(today, yearMonthDay));
  } else {
    const today = new Date(d.toString());
    response.send(await run(today, d.toString()));
  }
});

async function run(today: Date, yearMonthDay: string) {
  const status = await getPage(yearMonthDay);

  if (status == 200) {
    return {exist: true, body: `https://scrapbox.io/rtakaishi/${yearMonthDay}`};
  } else {
    const prevTitle = dayjs(new Date().setDate(today.getDate() - 1)).format("YYYY-MM-DD");
    const nextTitle = dayjs(new Date().setDate(today.getDate() + 1)).format("YYYY-MM-DD");

    const year = dayjs(today).locale("ja").format("YYYY");
    const yearMonth = dayjs(today).locale("ja").format("YYYY-MM");
    const monthDay = dayjs(today).locale("ja").format("MM-DD");

    const num = new Array(new Date().getFullYear() - 2020).fill(null).map((_, i) => i + 1);
    const nYearsAgo = num.map(function(n) {
      const tmp = new Date(today.toString())
      return `[${dayjs(tmp.setFullYear(tmp.getFullYear() - n)).format("YYYY-MM-DD")}]`;
    }).join("\n");
    const body = `
[Journal]  [${yearMonthDay}]  [${year}]  [${yearMonth}]  [${monthDay}]

[*** ナビ]

前日 [${prevTitle}]
翌日 [${nextTitle}]

[*** 今日の n 年前]

${nYearsAgo}

[*** 今日のインターネット]

`;
    return {exist: false, body: `https://scrapbox.io/rtakaishi/${yearMonthDay}?body=${encodeURI(body)}`};
  }
}

async function getPage(date: string) {
  const resp = await fetch(`https://scrapbox.io/rtakaishi/${date}/text`, {
    method: "GET",
    headers: {
      Accept: "application/json",
    },
  });
  return resp.status;
}
