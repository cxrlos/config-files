#!/bin/bash

# ===================================================================
#                        CONFIG SETUP SCRIPT
# ===================================================================
# Easy setup script to copy all config files to their proper locations
# Author: cxrlos
# Features: State tracking, force install option, smart package management
# ===================================================================

set -e

# State file for tracking installations
STATE_FILE="$HOME/.config-setup-state"
FORCE_INSTALL=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force-install)
            FORCE_INSTALL=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force-install    Force package validation and updates"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "The script will:"
            echo "  - Copy all config files to their proper locations"
            echo "  - Install required packages (only on first run or with --force-install)"
            echo "  - Track installation state to avoid unnecessary re-installations"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

echo "🚀 Setting up your configuration files..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ===================================================================
# STATE MANAGEMENT
# ===================================================================

# Initialize state file if it doesn't exist
init_state() {
    if [[ ! -f "$STATE_FILE" ]]; then
        echo "📝 Initializing setup state..."
        cat > "$STATE_FILE" << EOF
# Config Setup State File
# Generated on: $(date)
# System: $(uname -s)
# Packages installed: false
# Configs copied: false
PACKAGES_INSTALLED=false
CONFIGS_COPIED=false
LAST_RUN=$(date +%s)
EOF
    fi
}

# Read state from file
read_state() {
    if [[ -f "$STATE_FILE" ]]; then
        source "$STATE_FILE"
    else
        PACKAGES_INSTALLED=false
        CONFIGS_COPIED=false
    fi
}

# Write state to file
write_state() {
    cat > "$STATE_FILE" << EOF
# Config Setup State File
# Generated on: $(date)
# System: $(uname -s)
PACKAGES_INSTALLED=$PACKAGES_INSTALLED
CONFIGS_COPIED=$CONFIGS_COPIED
LAST_RUN=$(date +%s)
EOF
}

# ===================================================================
# SYSTEM DETECTION AND PACKAGE MANAGER SETUP
# ===================================================================

detect_system() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🍎 macOS detected"
        SYSTEM="macos"
        PACKAGE_MANAGER="brew"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v pacman &> /dev/null; then
            echo "🐧 Arch Linux detected"
            SYSTEM="arch"
            PACKAGE_MANAGER="pacman"
        else
            echo "❌ Unsupported Linux distribution"
            exit 1
        fi
    else
        echo "❌ Unsupported operating system"
        exit 1
    fi
}

# ===================================================================
# PACKAGE INSTALLATION FUNCTIONS
# ===================================================================

install_package() {
    local package=$1
    local description=$2
    
    echo "📦 Checking for $description..."
    
    if [[ "$SYSTEM" == "macos" ]]; then
        if ! brew list "$package" &> /dev/null 2>&1; then
            echo "   Installing $description..."
            if brew install "$package" &> /dev/null; then
                echo "   ✅ $description installed successfully"
            else
                echo "   ⚠️  Failed to install $description (may already be installed or unavailable)"
            fi
        else
            echo "   ✅ $description already installed"
        fi
    elif [[ "$SYSTEM" == "arch" ]]; then
        if ! pacman -Q "$package" &> /dev/null 2>&1; then
            echo "   Installing $description..."
            if sudo pacman -S --noconfirm "$package" &> /dev/null; then
                echo "   ✅ $description installed successfully"
            else
                echo "   ⚠️  Failed to install $description (may already be installed or unavailable)"
            fi
        else
            echo "   ✅ $description already installed"
        fi
    fi
}

install_aur_package() {
    local package=$1
    local description=$2
    
    echo "📦 Checking for $description (AUR)..."
    
    if ! pacman -Q "$package" &> /dev/null 2>&1; then
        echo "   Installing $description from AUR..."
        if yay -S --noconfirm "$package" &> /dev/null; then
            echo "   ✅ $description installed successfully"
        else
            echo "   ⚠️  Failed to install $description from AUR (may already be installed or unavailable)"
        fi
    else
        echo "   ✅ $description already installed"
    fi
}

# ===================================================================
# REQUIRED PACKAGES CHECK AND INSTALLATION
# ===================================================================

check_and_install_packages() {
    # Check if we should skip package installation
    if [[ "$PACKAGES_INSTALLED" == "true" && "$FORCE_INSTALL" == "false" ]]; then
        echo ""
        echo "📦 Package installation skipped (already completed)"
        echo "   Use --force-install to re-validate packages"
        return
    fi
    
    echo ""
    echo "🔍 Checking and installing required packages..."
    
    # Track installation status
    local failed_packages=()
    local successful_packages=()
    
    # Core packages
    install_package "alacritty" "Alacritty terminal"
    install_package "neofetch" "Neofetch system info"
    install_package "starship" "Starship prompt"
    install_package "zsh" "ZSH shell"
    install_package "neovim" "Neovim editor"
    
    # ZSH plugins
    if [[ "$SYSTEM" == "macos" ]]; then
        install_package "zsh-syntax-highlighting" "ZSH syntax highlighting"
        install_package "zsh-autosuggestions" "ZSH autosuggestions"
    elif [[ "$SYSTEM" == "arch" ]]; then
        install_package "zsh-syntax-highlighting" "ZSH syntax highlighting"
        install_package "zsh-autosuggestions" "ZSH autosuggestions"
    fi
    
    # Optional packages
    install_package "fzf" "Fuzzy finder"
    install_package "git" "Git version control"
    
    # Font installation - Nerd Fonts for glyphs
    if [[ "$SYSTEM" == "macos" ]]; then
        install_package "font-hack-nerd-font" "Hack Nerd Font (with glyphs)"
    elif [[ "$SYSTEM" == "arch" ]]; then
        install_aur_package "nerd-fonts-hack" "Hack Nerd Font (with glyphs)"
    fi
    
    # Mark packages as installed
    PACKAGES_INSTALLED=true
    write_state
    
    echo ""
    echo "📊 Installation Summary:"
    echo "✅ Core packages checked/installed"
    echo "✅ ZSH plugins checked/installed"
    echo "✅ Optional tools checked/installed"
    echo "✅ Fonts checked/installed"
}

# ===================================================================
# CONFIGURATION SETUP
# ===================================================================

setup_configs() {
    echo ""
    echo "📁 Creating directories..."
    mkdir -p ~/.config/alacritty ~/.config/neofetch ~/.zsh 2>/dev/null || {
        echo "⚠️  Warning: Could not create some directories (may already exist)"
    }

    # Copy Alacritty config
    echo "🖥️  Setting up Alacritty..."
    if [ -f "$SCRIPT_DIR/alacritty/alacritty.toml" ]; then
        if cp "$SCRIPT_DIR/alacritty/alacritty.toml" ~/.config/alacritty/ 2>/dev/null; then
            echo "✅ Alacritty config copied"
        else
            echo "⚠️  Warning: Could not copy Alacritty config (may already exist)"
        fi
    else
        echo "⚠️  Warning: Alacritty config not found"
    fi

    # Copy Neofetch config
    echo "🖼️  Setting up Neofetch..."
    if [ -f "$SCRIPT_DIR/neofetch/config.conf" ]; then
        if cp "$SCRIPT_DIR/neofetch/config.conf" ~/.config/neofetch/ 2>/dev/null; then
            echo "✅ Neofetch config copied"
        else
            echo "⚠️  Warning: Could not copy Neofetch config (may already exist)"
        fi
    else
        echo "⚠️  Warning: Neofetch config not found"
    fi

    # Copy ZSH configs
    echo "🐚 Setting up ZSH..."
    if [ -f "$SCRIPT_DIR/zsh/.zshrc" ]; then
        if cp "$SCRIPT_DIR/zsh/.zshrc" ~/ 2>/dev/null; then
            echo "✅ Main zshrc copied"
        else
            echo "⚠️  Warning: Could not copy main zshrc (may already exist)"
        fi
    else
        echo "⚠️  Warning: Main zshrc not found"
    fi

    # Copy modular ZSH configs
    if [ -d "$SCRIPT_DIR/zsh" ]; then
        local copied_count=0
        for file in "$SCRIPT_DIR"/zsh/*.zsh; do
            if [ -f "$file" ]; then
                if cp "$file" ~/.zsh/ 2>/dev/null; then
                    echo "✅ Copied $(basename "$file")"
                    ((copied_count++))
                else
                    echo "⚠️  Warning: Could not copy $(basename "$file") (may already exist)"
                fi
            fi
        done
        if [ $copied_count -eq 0 ]; then
            echo "⚠️  Warning: No ZSH config files found to copy"
        fi
    else
        echo "⚠️  Warning: ZSH config directory not found"
    fi

    # Copy Neovim config (if exists)
    echo "📝 Setting up Neovim..."
    if [ -d "$SCRIPT_DIR/nvim" ]; then
        if cp -r "$SCRIPT_DIR/nvim" ~/.config/ 2>/dev/null; then
            echo "✅ Neovim config copied"
        else
            echo "⚠️  Warning: Could not copy Neovim config (may already exist)"
        fi
    else
        echo "⚠️  Warning: Neovim config not found"
    fi

    # Copy Starship config (if exists)
    echo "⭐ Setting up Starship..."
    if [ -f "$SCRIPT_DIR/starship/starship.toml" ]; then
        if cp "$SCRIPT_DIR/starship/starship.toml" ~/.config/ 2>/dev/null; then
            echo "✅ Starship config copied"
        else
            echo "⚠️  Warning: Could not copy Starship config (may already exist)"
        fi
    else
        echo "⚠️  Warning: Starship config not found"
    fi

    # Copy Cursor config (if exists)
    echo "🎯 Setting up Cursor..."
    if [ -f "$SCRIPT_DIR/cursor/settings.json" ]; then
        # Create Cursor config directory
        mkdir -p ~/Library/Application\ Support/Cursor/User 2>/dev/null || true
        if cp "$SCRIPT_DIR/cursor/settings.json" ~/Library/Application\ Support/Cursor/User/ 2>/dev/null; then
            echo "✅ Cursor config copied"
        else
            echo "⚠️  Warning: Could not copy Cursor config (may already exist)"
        fi
    else
        echo "⚠️  Warning: Cursor config not found"
    fi
    
    # Mark configs as copied
    CONFIGS_COPIED=true
    write_state
}

# ===================================================================
# MAIN EXECUTION
# ===================================================================

# Initialize state management
init_state
read_state

# Detect system and package manager
detect_system

# Check and install required packages
check_and_install_packages

# Setup configurations
setup_configs

# Final status check
echo ""
echo "🔍 Final Status Check:"
if command -v alacritty &> /dev/null; then echo "✅ Alacritty available"; else echo "⚠️  Alacritty not found"; fi
if command -v neofetch &> /dev/null; then echo "✅ Neofetch available"; else echo "⚠️  Neofetch not found"; fi
if command -v starship &> /dev/null; then echo "✅ Starship available"; else echo "⚠️  Starship not found"; fi
if command -v nvim &> /dev/null; then echo "✅ Neovim available"; else echo "⚠️  Neovim not found"; fi
if command -v cursor &> /dev/null; then echo "✅ Cursor available"; else echo "⚠️  Cursor not found (install from https://cursor.sh)"; fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. If you're on macOS, you might need to set Hack as your terminal font"
echo "3. Enjoy your new setup! 🚀"
echo ""
echo "🔧 Your configs are now in:"
echo "   - ~/.zshrc (main zsh config)"
echo "   - ~/.zsh/ (modular zsh configs)"
echo "   - ~/.config/alacritty/ (terminal config)"
echo "   - ~/.config/neofetch/ (system info config)"
echo "   - ~/.config/nvim/ (editor config)"
echo ""
echo "📦 Installed packages:"
echo "   - Alacritty (terminal)"
echo "   - Neofetch (system info)"
echo "   - Starship (prompt)"
echo "   - Neovim (editor)"
echo "   - ZSH plugins (syntax highlighting, autosuggestions)"
echo "   - FZF (fuzzy finder)"
echo "   - Hack font"
echo ""
echo "📝 State file: $STATE_FILE"
echo "   Use --force-install to re-validate packages" 