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

# ===================================================================
# LS_COLORS CONFIGURATION (Nord Theme)
# ===================================================================

export LS_COLORS="di=1;34:fi=0;37:ln=1;36:pi=40;33:so=1;35:bd=40;33;1:cd=40;33;1:or=41;33;1:ex=1;32:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.tz=1;31:*.deb=1;31:*.rpm=1;31:*.jar=1;31:*.jpg=1;35:*.jpeg=1;35:*.gif=1;35:*.bmp=1;35:*.pbm=1;35:*.pgm=1;35:*.ppm=1;35:*.tga=1;35:*.xbm=1;35:*.xpm=1;35:*.tif=1;35:*.tiff=1;35:*.png=1;35:*.mov=1;35:*.mpg=1;35:*.mpeg=1;35:*.avi=1;35:*.fli=1;35:*.gl=1;35:*.dl=1;35:*.xcf=1;35:*.xwd=1;35:*.ogg=1;35:*.mp3=1;35:*.wav=1;35:*.py=1;33:*.js=1;33:*.json=1;33:*.html=1;33:*.css=1;33:*.md=1;33:*.txt=0;37:*.log=0;37"

# Enable color support for ls
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
    alias ll='ls -lG'
    alias la='ls -laG'
    alias l='ls -lG'
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    alias ls='ls --color=auto'
    alias ll='ls -l --color=auto'
    alias la='ls -la --color=auto'
    alias l='ls -l --color=auto'
fi 