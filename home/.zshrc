# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
export PATH="/usr/local/bin/:~/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH
export EDITOR=vim

##
# History
##
HISTFILE=~/.zhistory            # where to store zsh config
HISTSIZE=10240                  # big history
SAVEHIST=10240                  # big history
setopt append_history           # 複数のzshを使ったときにヒストリを上書きではなく追加する
setopt hist_ignore_all_dups     # 重複しないようにする
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
setopt share_history            # share hist between sessions
setopt bang_hist                # !keyword

##
# Alias
##
alias gl='cd $(ghq root)/$(ghq list | peco)'
alias gd='git diff --color -w'

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

# zshにpeco + ghqを導入したメモ - Qiita - http://qiita.com/ysk_1031/items/8cde9ce8b4d0870a129d
#
# $ brew tap peco/peco
# $ brew install peco
#
# $ brew tap motemen/ghq
# $ brew install ghq
#
if type peco > /dev/null 2>&1; then
    setopt hist_ignore_all_dups
    function peco_select_history() {
        local tac
        if which tac > /dev/null; then
            tac="tac"
        else
            tac="tail -r"
        fi
        BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER")
        CURSOR=$#BUFFER
        zle clear-screen
    }
    zle -N peco_select_history
    bindkey '^r' peco_select_history
else
    echo "peco is not found."
fi

function _peco_ssh () {
  peco | xargs -I{} bash -c "ssh {} < /dev/tty";
}

for file in `ls $HOME/.zsh.d`; do
  source $HOME/.zsh.d/$file
done

autoload -U compinit
compinit -u

eval "$(direnv hook zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/r_takaishi/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/r_takaishi/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/r_takaishi/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/r_takaishi/google-cloud-sdk/completion.zsh.inc'; fi
