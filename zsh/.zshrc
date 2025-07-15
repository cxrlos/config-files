# ===================================================================
#                        MODERN ZSH CONFIGURATION
# ===================================================================
# Modular zsh setup with Starship prompt
# Author: cxrlos
# Features: Fast, modern, cross-platform compatible
# ===================================================================

# ===================================================================
# CORE CONFIGURATION
# ===================================================================

# Suppress "Last login" message
touch ~/.hushlogin

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Better directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

# Completion system
autoload -Uz compinit
compinit

# ===================================================================
# MODULAR CONFIGURATION
# ===================================================================

# Source modular configuration files
ZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}/.zsh"

# Load all config files
for config_file in $ZSH_CONFIG_DIR/*.zsh; do
    if [[ -f "$config_file" ]]; then
        source "$config_file"
    fi
done

# ===================================================================
# STARSHIP PROMPT
# ===================================================================

# Initialize Starship prompt
eval "$(starship init zsh)"

# ===================================================================
# STARTUP COMMANDS
# ===================================================================

# Start new tabs in root directory (works with Alacritty on macOS and Linux)
# Check if this is a new shell session and change to root
if [[ "$SHLVL" == "1" ]] && [[ "$PWD" != "/" ]]; then
    cd ~
fi

# Show system info on startup
neofetch 