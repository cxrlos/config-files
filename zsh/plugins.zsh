# ===================================================================
# PLUGINS AND TOOLS CONFIGURATION
# ===================================================================

# ===================================================================
# COMPLETION CONFIGURATION
# ===================================================================

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Substring completion (what you want)
zstyle ':completion:*' matcher-list 'r:|?=** m:{a-z}={A-Z}'

# Partial completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# Cache completion for better performance
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# History substring search (for up/down arrow behavior)
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# ===================================================================
# PLUGIN LOADING
# ===================================================================

# FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Zsh syntax highlighting (if installed)
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Zsh autosuggestions (if installed)
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi 