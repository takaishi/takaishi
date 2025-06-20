# ==================================================
# ZSH Configuration File
# ==================================================
# This file contains personal zsh configuration organized by category:
# 1. Basic ZSH Settings
# 2. Zim Framework Configuration  
# 3. History Management
# 4. Key Bindings & Input
# 5. Aliases
# 6. Custom Functions
# 7. Directory Navigation
# 8. Development Environment
# 9. Tool Integrations
# 10. Cloud & Security
# 11. Completion System
# ==================================================

# ==================================================
# 1. BASIC ZSH SETTINGS
# ==================================================

# Set editor default keymap to emacs
bindkey -e

# Remove path separator from WORDCHARS
WORDCHARS=${WORDCHARS//[\/]}

# Basic environment
export EDITOR=vim

# ==================================================
# 2. ZIM FRAMEWORK CONFIGURATION
# ==================================================

# Start configuration added by Zim install {{{
# Download zimfw plugin manager if missing
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules
source ${ZIM_HOME}/init.zsh

# Zim module configuration
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
# }}} End configuration added by Zim install

# ==================================================
# 3. HISTORY MANAGEMENT
# ==================================================

# History file and size
export HISTFILE="$XDG_DATA_HOME"/zsh/history
export HISTSIZE=100000
export SAVEHIST=100000
HISTORY_IGNORE="(ls|pwd|cd)*"

# History options
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt append_history
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt bang_hist

# ==================================================
# 4. KEY BINDINGS & INPUT
# ==================================================

# History substring search bindings
zmodload -F zsh/terminfo +p:terminfo
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key

# Custom key bindings
bindkey '^g' fzf-ghq
bindkey '^z' zi
bindkey '^b' select-git-branch-friendly

# ==================================================
# 5. ALIASES
# ==================================================

# Git aliases
alias g='git'
alias gd='git diff --color -w'

# Kubernetes
alias k='kubectl'

# Directory navigation
alias gl='cd $(ghq root)/$(ghq list | peco)'

# Diff with color
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

# GNU sed on macOS
if [ -f '/opt/homebrew/bin/gsed' ]; then
  alias sed='gsed'
fi

# ==================================================
# 6. CUSTOM FUNCTIONS
# ==================================================

# fzf + ghq integration for repository navigation
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

# Git branch selection with fzf
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

# Navigate to git repository root
function u() {
  cd ./"$(git rev-parse --show-cdup)"
  if [ $# = 1 ]; then
    cd "$1"
  fi
}

# AWS CloudWatch logs viewer with fzf
awslogs() {
  set -e
  export AWS_PROFILE=$(cat ~/.aws/config | awk '/^\[profile /{print $2}' | tr -d ']' | fzf)
  local log_group=$(aws logs describe-log-groups | jq -r '.logGroups[].logGroupName' | fzf)
  aws logs tail "$log_group" --since 3h --follow --format=short
}

# Security function to prevent accidental secret exposure
function preexec() {
  local secret_regex="(AKIA[0-9A-Z]{16}|[Aa][Ww][Ss].{0,20}[\"'][0-9A-Za-z/+=]{40}[\"']|ghp_[0-9A-Za-z]{36}|github_pat_[0-9A-Za-z]{22}_[0-9A-Za-z]{59}|AIza[0-9A-Za-z_\-]{35}|xox[baprs]-[0-9]{11}-[0-9]{11}-[0-9A-Za-z]{24}|sk_live_[0-9A-Za-z]{24}|sk-[A-Za-z0-9]{48}|-----BEGIN[[:space:]]+(EC|PGP|DSA|RSA|OPENSSH)?PRIVATE[[:space:]]+KEY)"
  if print "$1" | grep -Eq "$secret_regex"; then
    echo "🚫 シークレットらしき文字列が検出されました。コマンドの実行を中止します。"
    kill -SIGINT $$
  fi
}

# ==================================================
# 7. DIRECTORY NAVIGATION
# ==================================================

# Recent directory tracking (cdr)
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-max 100
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-insert true
zstyle ':chpwd:*' recent-dirs-file "$XDG_DATA_HOME"/zsh/chpwd-recent-dirs

# Auto cd paths
cdpath=(~ ..)

# ==================================================
# 8. DEVELOPMENT ENVIRONMENT
# ==================================================

# Version managers
eval "$(nodenv init -)"
eval "$(rbenv init -)"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Environment management
eval "$(direnv hook zsh)"

# ==================================================
# 9. TOOL INTEGRATIONS
# ==================================================

# FZF setup and configuration
if [ ! -f ~/.fzf.zsh ]; then
  /opt/homebrew/opt/fzf/install
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--reverse --no-sort --no-hscroll --preview-window=down"

# Zoxide (smart cd)
eval "$(zoxide init zsh)"
zle -N zi

# Atuin (shell history)
eval "$(atuin init zsh --disable-up-arrow)"

# History substring search
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# VS Code shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# 1Password CLI
if [ -f '~/.config/op/plugins.sh' ]; then
  source /Users/r_takaishi/.config/op/plugins.sh
fi

# ==================================================
# 10. CLOUD & EXTERNAL SERVICES
# ==================================================

# Google Cloud SDK
if [ -f '/Users/r_takaishi/opt/google-cloud-sdk/path.zsh.inc' ]; then
  . '/Users/r_takaishi/opt/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/Users/r_takaishi/opt/google-cloud-sdk/completion.zsh.inc' ]; then
  . '/Users/r_takaishi/opt/google-cloud-sdk/completion.zsh.inc'
fi

# Alternative Google Cloud SDK paths
if [ -f '~/opt/google-cloud-sdk/path.zsh.inc' ]; then
  . '~/opt/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '~/opt/google-cloud-sdk/completion.zsh.inc' ]; then
  . '~/opt/google-cloud-sdk/completion.zsh.inc'
fi

# ==================================================
# 11. COMPLETION SYSTEM
# ==================================================

# Basic completion setup
autoload -U compinit
compinit -u

# Homebrew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi

# ==================================================
# LEGACY/DISABLED CONFIGURATION
# ==================================================
# The following sections are commented out but kept for reference

# Fig integration (disabled)
#[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
#[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

# Amazon Q integration (disabled)
#[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
#[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# Navi widget (disabled)
# eval "$(navi widget zsh)"

# Additional zim module configuration (commented for reference)
#zstyle ':zim:zmodule' use 'degit'
#zstyle ':zim:git' aliases-prefix 'g'
#zstyle ':zim:input' double-dot-expand yes
#zstyle ':zim:termtitle' format '%1~'
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'
#setopt CORRECT
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '