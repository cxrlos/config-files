# Base config
ENABLE_CORRECTION="true"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting golang)
 
export ZSH="$HOME/.oh-my-zsh"
export KAFKA="$HOME/Documents/confluent-7.5.2"

source $ZSH/oh-my-zsh.sh
fpath+=$HOME/.zsh/pure

# Pure ZSH
autoload -U promptinit; promptinit
PURE_CMD_MAX_EXEC_TIME=10
zstyle :prompt:pure:path color white
zstyle ':prompt:pure:prompt:*' color cyan
zstyle :prompt:pure:git:stash show yes
prompt pure
 
# Had a MacBook, self explanatory 
alias vi='nvim'
alias vim='nvim'
alias python='python3'
alias pip='pip3'

# Vim syntax, cuz emacs syntax sux
set -o vi

# Screenfetch prompt
neofetch

# Disabled correction because I started using thefuck
unsetopt correct_all
eval $(thefuck --alias)

# <-- BEGIN SECTION ADDED BY NUDEV -->

# To handle non-ASCII characters
# ==============================
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8


# Programs
# ========

# Default editor
# --------------
export EDITOR="subl -w -n"

# Homebrew
# --------
if command -v brew >/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  export PATH="${HOMEBREW_PREFIX}/sbin:${PATH}"
elif [[ -f "/opt/homebrew/bin/brew" && $(/usr/bin/uname -sm) == "Darwin arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="${HOMEBREW_PREFIX}/sbin:${PATH}"
fi

# SDKMAN
# ------
if [[ -f "$HOME/.sdkman/bin/sdkman-init.sh" && $(/usr/bin/uname -sm) == "Darwin arm64" ]]; then
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# jEnv
# ----
if command -v jenv >/dev/null; then
  export PATH="${HOME}/.jenv/bin:${PATH}"
  eval "$(jenv init -)"
fi

# node
# ----
# https://nodejs.org/api/modules.html
if command -v node >/dev/null && [[ -n "$HOMEBREW_PREFIX" ]]; then
  export NODE_PATH="${HOMEBREW_PREFIX}/lib/node_modules"
fi

# Nu
# --
export NU_HOME="/Users/carlos.garcia/dev/nu"
export NUCLI_HOME="${NU_HOME}/nucli"
export PATH="${NUCLI_HOME}:${PATH}"
export NU_COUNTRY="br"
alias dev='cd ${NU_HOME}'


# Autocomplete
# ============

# https://docs.brew.sh/Shell-Completion
if command -v brew >/dev/null && [[ $(ps -p "$$" -o comm=) == *bash ]]; then

  # https://formulae.brew.sh/formula/bash-completion@2
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" || :
  fi

fi

# nucli
if [[ -r "${NUCLI_HOME}/nu.bashcompletion" ]]; then
  . "${NUCLI_HOME}/nu.bashcompletion" || :
fi

# <-- END SECTION ADDED BY NUDEV -->

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
