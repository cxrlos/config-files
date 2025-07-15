# ===================================================================
# ENVIRONMENT VARIABLES CONFIGURATION
# ===================================================================

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Language and locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Path additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# ===================================================================
# PLATFORM SPECIFIC CONFIGURATIONS
# ===================================================================

# macOS specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Linux specific configurations
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Add local bin to PATH
    export PATH="$HOME/.local/bin:$PATH"
fi 