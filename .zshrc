# Base config
ENABLE_CORRECTION="true"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting golang)
 
export ZSH="$HOME/.oh-my-zsh"

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
alias whoops='fuck'
alias typora="open -a typora"
alias gfmt="git add . && git commit -m \"Formatting\" && git push"

# To create branch names
gconb() {
    if [ $# -eq 0 ]; then
        echo "Error: Please provide at least one component for the branch name." >&2
        return 1
    fi

    local date
    date=$(date +%Y-%m-%d)

    local branch_parts
    branch_parts=$(IFS=/; echo "$*")

    local branch_name="${date}/${branch_parts}"

    git checkout -b "$branch_name"
}


# Vim syntax, cuz emacs syntax sux
set -o vi

# Screenfetch prompt
neofetch

# Disabled correction because I started using thefuck
unsetopt correct_all
eval $(thefuck --alias)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

