# Lazy loading utility functions

# Generic lazy load function
lazy_load() {
  local cmd="$1"
  local init_cmd="$2"
  
  eval "
    $cmd() {
      unfunction $cmd
      $init_cmd
      $cmd \"\$@\"
    }
  "
}

# Lazy load nodenv
lazy_load_nodenv() {
  lazy_load nodenv 'eval "$(command nodenv init -)"'
  lazy_load node 'eval "$(command nodenv init -)"'
  lazy_load npm 'eval "$(command nodenv init -)"'
  lazy_load npx 'eval "$(command nodenv init -)"'
  lazy_load yarn 'eval "$(command nodenv init -)"'
}

# Lazy load rbenv
lazy_load_rbenv() {
  lazy_load rbenv 'eval "$(command rbenv init -)"'
  lazy_load ruby 'eval "$(command rbenv init -)"'
  lazy_load gem 'eval "$(command rbenv init -)"'
  lazy_load bundle 'eval "$(command rbenv init -)"'
}

# Lazy load pyenv
lazy_load_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  lazy_load pyenv 'eval "$(command pyenv init --path)" && eval "$(command pyenv init -)"'
  lazy_load python 'eval "$(command pyenv init --path)" && eval "$(command pyenv init -)"'
  lazy_load python3 'eval "$(command pyenv init --path)" && eval "$(command pyenv init -)"'
  lazy_load pip 'eval "$(command pyenv init --path)" && eval "$(command pyenv init -)"'
  lazy_load pip3 'eval "$(command pyenv init --path)" && eval "$(command pyenv init -)"'
}

# Lazy load Google Cloud SDK
lazy_load_gcloud() {
  if [ -f "$HOME/opt/google-cloud-sdk/path.zsh.inc" ]; then
    lazy_load gcloud '. "$HOME/opt/google-cloud-sdk/path.zsh.inc" && . "$HOME/opt/google-cloud-sdk/completion.zsh.inc"'
    lazy_load gsutil '. "$HOME/opt/google-cloud-sdk/path.zsh.inc" && . "$HOME/opt/google-cloud-sdk/completion.zsh.inc"'
    lazy_load bq '. "$HOME/opt/google-cloud-sdk/path.zsh.inc" && . "$HOME/opt/google-cloud-sdk/completion.zsh.inc"'
  fi
}