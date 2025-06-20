export ZDOTDIR=$HOME/.config/zsh


case $(uname -m) in
  x86_64 ) export HOMEBREW_DIR=/usr/local ;;
  arm64 ) export HOMEBREW_DIR=/opt/homebrew ;;
esac
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_CACHE_HOME="$HOME"/.cache
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_STATE_HOME="$HOME"/.local/state
export FZF_DEFAULT_OPTS='--layout=reverse --border --exit-0'

export PATH=$HOMEBREW_DIR/bin:$PATH
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOMEBREW_DIR/kubebuilder/bin/:$PATH
export PATH=$HOMEBREW_DIR/python/libexec/bin:$PATH
export PATH=$HOME/Library/Python/3.7/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$HOME/.nodenv/shims:$PATH
export PATH=$HOME/.asdf/shims:$PATH
export PATH=$HOME/src/github.com/takaishi/takaishi/toolbox:$PATH
export PATH=$HOME/Library/Application\ Support/JetBrains/Toolbox/scripts:$PATH

export PATH=$HOMEBREW_DIR/opt/gnu-time/libexec/gnubin:$PATH
export PATH=$HOME/.krew/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=$HOME/flutter/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOMEBREW_DIR/bin:$PATH
export PATH=$HOMEBREW_DIR/opt/gnu-sed/libexec/gnubin:$PATH
export PATH=$HOMEBREW_DIR/opt/coreutils/libexec/gnubin:$PATH
export PATH=/usr/local/opt/libxml2/bin:$PATH
export PATH=$HOMEBREW_DIR/opt/avr-gcc@8/bin:$PATH
export PATH=$HOMEBREW_DIR/opt/gnu-sed/libexec/gnubin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export GOPATH=$HOME
export GO111MODULE=on
export LANG=en_US.UTF-8
export DYLD_LIBRARY_PATH=$HOMEBREW_DIR/Cellar/openssl/1.0.2s/lib
export QMK_HOME=$HOME/src/github.com/takaishi/qmk_firmware
export RUBY_CONFIGURE_OPTS=--with-openssl-dir=$HOMEBREW_DIR/opt/openssl@1.1
export PATH=$HOME/opt/google-cloud-sdk/bin:$PATH
export PATH=/opt/homebrew/opt/postgresql@16/bin:$PATH
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"




export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$HOME/.pyenv/shims:$PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export GPG_TTY=$(tty)
#. "$HOME/.cargo/env"
