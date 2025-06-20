# Fig pre block. Keep at the top of this file.
#[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'
alias g='git'
alias gd='git diff'
alias k='kubectl'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

export HISTFILE="$XDG_DATA_HOME"/zsh/history
export HISTSIZE=100000
export SAVEHIST=100000
HISTORY_IGNORE="(ls|pwd|cd)*"
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

setopt share_history
setopt append_history
setopt hist_ignore_all_dups

if [ ! -f ~/.fzf.zsh ]; then
  /opt/homebrew/opt/fzf/install
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh


fzf-ghq() {
  local repo=$(ghq list | fzf)
  if [ -n "$repo" ]; then
    repo=$(ghq list --full-path --exact $repo)
    BUFFER="cd ${repo}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq
bindkey '^g' fzf-ghq


# cdrを有効にして設定する
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-max 100
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-insert true
zstyle ':chpwd:*' recent-dirs-file "$XDG_DATA_HOME"/zsh/chpwd-recent-dirs

# AUTO_CDの対象に ~ と上位ディレクトリを加える
#
cdpath=(~ ..)

function u() {
  cd ./"$(git rev-parse --show-cdup)"
  if [ $# = 1 ]; then
    cd "$1"
  fi
}

eval "$(nodenv init -)"
eval "$(rbenv init -)"
export EDITOR=vim
eval "$(direnv hook zsh)"


eval "$(zoxide init zsh)"
zle -N zi
bindkey '^z' zi


# Fig post block. Keep at the bottom of this file.
#[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/opt/google-cloud-sdk/path.zsh.inc' ]; then . '~/opt/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '~/opt/google-cloud-sdk/completion.zsh.inc'; fi


# eval "$(navi widget zsh)"

if [ -f '/opt/homebrew/bin/gsed' ]; then
  alias sed='gsed'
fi


eval "$(atuin init zsh --disable-up-arrow)"

if [ -f '~/.config/op/plugins.sh' ]; then
  source /Users/r_takaishi/.config/op/plugins.sh
fi

# # https://www.mizdra.net/entry/2024/10/19/172323
export FZF_DEFAULT_OPTS="--reverse --no-sort --no-hscroll --preview-window=down"

user_name=$(git config user.name)
fmt="\
%(if:equals=$user_name)%(authorname)%(then)%(color:default)%(else)%(color:brightred)%(end)%(refname:short)|\
%(committerdate:relative)|\
%(subject)"
function select-git-branch-friendly() {
  selected_branch=$(
    git branch --sort=-committerdate --format=$fmt --color=always \
    | column -ts'|' \
    | fzf --ansi --exact --preview='git log --oneline --graph --decorate --color=always -50 {+1}' \
    | awk '{print $1}' \
  )
  BUFFER="${LBUFFER}${selected_branch}${RBUFFER}"
  CURSOR=$#LBUFFER+$#selected_branch
  zle redisplay
}
zle -N select-git-branch-friendly
bindkey '^b' select-git-branch-friendly

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"


eval "$(pyenv init --path)"
eval "$(pyenv init -)"


function preexec() {
  local secret_regex="(AKIA[0-9A-Z]{16}|[Aa][Ww][Ss].{0,20}[\"'][0-9A-Za-z/+=]{40}[\"']|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z]{22}_[0-9A-Za-z]{59}|AIza[0-9A-Za-z_\-]{35}|xox[baprs]-[0-9]{11}-[0-9]{11}-[0-9A-Za-z]{24}|sk_live_[0-9A-Za-z]{24}|sk-[A-Za-z0-9]{48}|-----BEGIN[[:space:]]+(EC|PGP|DSA|RSA|OPENSSH)?PRIVATE[[:space:]]+KEY)"
  if print "$1" | grep -Eq "$secret_regex"; then
    echo "🚫 シークレットらしき文字列が検出されました。コマンドの実行を中止します。"
    kill -SIGINT $$
  fi
}

awslogs() {
  set -e
  export AWS_PROFILE=$(cat ~/.aws/config | awk '/^\[profile /{print $2}' | tr -d ']' | fzf)
  local log_group=$(aws logs describe-log-groups | jq -r '.logGroups[].logGroupName' | fzf)
  aws logs tail "$log_group" --since 3h --follow --format=short
}

# # Merged from home/.zshrc
# # Amazon Q pre block. Keep at the top of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# # Fig pre block. Keep at the top of this file.
# [[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# export PATH="/usr/local/bin/:~/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
# eval "$(rbenv init -)"
# export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
# export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
# export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# export PATH=$HOME/.nodebrew/current/bin:$PATH
# export EDITOR=vim

# ##
# # History (merged settings)
# ##
# HISTFILE=~/.zhistory            # where to store zsh config
# HISTSIZE=10240                  # big history
# SAVEHIST=10240                  # big history
# setopt append_history           # 複数のzshを使ったときにヒストリを上書きではなく追加する
# setopt hist_ignore_all_dups     # 重複しないようにする
# unsetopt hist_ignore_space      # ignore space prefixed commands
# setopt hist_reduce_blanks       # trim blanks
# setopt hist_verify              # show before executing history commands
# setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
# setopt share_history            # share hist between sessions
# setopt bang_hist                # !keyword

# ##
# # Alias
# ##
# alias gl='cd $(ghq root)/$(ghq list | peco)'
# alias gd='git diff --color -w'

# if [[ -x `which colordiff` ]]; then
#   alias diff='colordiff -u'
# else
#   alias diff='diff -u'
# fi

# # zshにpeco + ghqを導入したメモ - Qiita - http://qiita.com/ysk_1031/items/8cde9ce8b4d0870a129d
# #
# # $ brew tap peco/peco
# # $ brew install peco
# #
# # $ brew tap motemen/ghq
# # $ brew install ghq
# #
# if type peco > /dev/null 2>&1; then
#     setopt hist_ignore_all_dups
#     function peco_select_history() {
#         local tac
#         if which tac > /dev/null; then
#             tac="tac"
#         else
#             tac="tail -r"
#         fi
#         BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
#         CURSOR=$#BUFFER
#         zle clear-screen
#     }
#     zle -N peco_select_history
#     bindkey '^r' peco_select_history
# else
#     echo "peco is not found."
# fi

# function _peco_ssh () {
#   peco | xargs -I{} bash -c "ssh {} < /dev/tty";
# }

# for file in `ls $HOME/.zsh.d`; do
#   source $HOME/.zsh.d/$file
# done

# autoload -U compinit
# compinit -u

# eval "$(direnv hook zsh)"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# # Fig post block. Keep at the bottom of this file.
# [[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/r_takaishi/opt/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/r_takaishi/opt/google-cloud-sdk/path.zsh.inc'; fi

# # The next line enables shell command completion for gcloud.
# if [ -f '/Users/r_takaishi/opt/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/r_takaishi/opt/google-cloud-sdk/completion.zsh.inc'; fi

# # Amazon Q post block. Keep at the bottom of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
