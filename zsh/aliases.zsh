# ===================================================================
# ALIASES CONFIGURATION
# ===================================================================

# Editor aliases
alias vi='nvim'
alias vim='nvim'
alias edit='nvim'

# Python aliases
alias python='python3'
alias pip='pip3'
alias py='python3'
alias venv='python3 -m venv .venv && source .venv/bin/activate'

# Git aliases
alias gss="git status --short"
alias ga='git add'
alias gaa='git add --all'
alias gcm='git commit -m'
alias gcam='git add . && git commit -m'
alias gc='git commit'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gl='git pull'
alias gco='git checkout'
alias gcb='git checkout -b'

# Beautiful git log aliases with Nord colors
alias glol='git log --graph --pretty=format:"%C(#88C0D0)%h%Creset -%C(#BF616A)%d%Creset %s %C(#A3BE8C)(%cr) %C(#81A1C1)<%an>%Creset" --abbrev-commit'
alias glols='git log --graph --pretty=format:"%C(#88C0D0)%h%Creset -%C(#BF616A)%d%Creset %s %C(#A3BE8C)(%cr) %C(#81A1C1)<%an>%Creset" --abbrev-commit --stat'
alias glola='git log --graph --pretty=format:"%C(#88C0D0)%h%Creset -%C(#BF616A)%d%Creset %s %C(#A3BE8C)(%cr) %C(#81A1C1)<%an>%Creset" --abbrev-commit --all'

# Quick branch creation aliases (gconb shortcuts)
alias gbf='gconb feat'
alias gbb='gconb fix'
alias gbd='gconb docs'
alias gbs='gconb style'
alias gbr='gconb refactor'
alias gbt='gconb test'
alias gbc='gconb chore'
alias grh='git reset --hard'
alias grhh='git reset HEAD --hard'
alias gcl='git clone'

# System aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# macOS specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
fi

# ===================================================================
# Utility: Pretty-print all aliases
# ===================================================================
# `asliases` prints every defined alias in a color-highlighted, neatly
# aligned table so it is easy to scan. It sorts aliases
# alphabetically, strips the surrounding quotes, and highlights the
# alias name in cyan.
#
# Example output:
#   gco                 : git checkout
#   ll                  : ls -la
# -------------------------------------------------------------------
aliases() {
    alias | sort | while read -r line; do
        name="${line%%=*}"
        name="${name#alias }"
        value="${line#*=}"
        value="${value//\'/}"
        printf '\033[1;36m%-20s\033[0m : %s\n' "$name" "$value"
    done
}
