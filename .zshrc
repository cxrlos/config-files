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
# To create branch names
gconb() {
    local date=$(date +%Y-%m-%d)
    local branch_name="$1/${date}/$2"
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
