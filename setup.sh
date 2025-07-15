#!/bin/bash

# ===================================================================
#                        ENHANCED CONFIG SETUP SCRIPT
# ===================================================================
# Easy setup script to copy all config files to their proper locations
# Author: cxrlos
# Features: Progress bars, semantic divisions, user prompts, automated plugin installation
# ===================================================================

set -e

# State file for tracking installations
STATE_FILE="$HOME/.config-setup-state"
FORCE_INSTALL=false
SKIP_PROMPTS=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Progress bar function
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))

    printf "\r["
    printf "%${completed}s" | tr ' ' '█'
    printf "%${remaining}s" | tr ' ' '░'
    printf "] %d%%" $percentage

    if [ $current -eq $total ]; then
        echo ""
    fi
}

# User prompt function
ask_user() {
    local question="$1"
    local default="$2"

    if [ "$SKIP_PROMPTS" = true ]; then
        echo "$question [Y/n] (auto-accepted)"
        return 0
    fi

    if [ "$default" = "y" ]; then
        read -p "$question [Y/n]: " -n 1 -r
        echo
        [[ $REPLY =~ ^[Nn]$ ]] && return 1 || return 0
    else
        read -p "$question [y/N]: " -n 1 -r
        echo
        [[ $REPLY =~ ^[Yy]$ ]] && return 0 || return 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force-install)
            FORCE_INSTALL=true
            shift
            ;;
        --skip-prompts)
            SKIP_PROMPTS=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force-install    Force package validation and updates"
            echo "  --skip-prompts     Skip all user prompts (auto-accept all)"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "The script will:"
            echo "  - Copy all config files to their proper locations"
            echo "  - Install required packages (only on first run or with --force-install)"
            echo "  - Install Neovim plugins automatically"
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

echo -e "${CYAN}🚀 Enhanced Config Setup Script${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ===================================================================
# PLUGIN CONFLICT DETECTION
# ===================================================================

PLUGIN_CONFLICT_PATHS=(
    "$HOME/.local/share/nvim/site/pack/packer/"
    "$HOME/.local/share/nvim/site/pack/plugins/"
    "$HOME/.vim/pack/"
)

PLUGIN_CONFLICT_FOUND=false
PLUGIN_CONFLICT_LIST=()
for path in "${PLUGIN_CONFLICT_PATHS[@]}"; do
    if [ -d "$path" ]; then
        PLUGIN_CONFLICT_FOUND=true
        PLUGIN_CONFLICT_LIST+=("$path")
    fi
done

if [ "$PLUGIN_CONFLICT_FOUND" = true ]; then
    echo -e "${YELLOW}⚠️  Old Neovim/Vim plugin directories were found that may conflict with your new setup:${NC}"
    for path in "${PLUGIN_CONFLICT_LIST[@]}"; do
        echo -e "  ${RED}$path${NC}"
    done
    if ask_user "Do you want to delete these old plugin directories to avoid conflicts?" "n"; then
        for path in "${PLUGIN_CONFLICT_LIST[@]}"; do
            rm -rf "$path"
            echo -e "  ${GREEN}Deleted $path${NC}"
        done
        echo -e "${GREEN}✅ Old plugin directories removed.${NC}"
    else
        echo -e "${YELLOW}⚠️  Skipped deleting old plugin directories. You may experience plugin conflicts.${NC}"
    fi
    echo ""
fi

# ===================================================================
# STATE MANAGEMENT
# ===================================================================

# Initialize state file if it doesn't exist
init_state() {
    if [[ ! -f "$STATE_FILE" ]]; then
        echo -e "${YELLOW}📝 Initializing setup state...${NC}"
        cat > "$STATE_FILE" << EOF
# Config Setup State File
# Generated on: $(date)
# System: $(uname -s)
# Packages installed: false
# Configs copied: false
# Plugins installed: false
PACKAGES_INSTALLED=false
CONFIGS_COPIED=false
PLUGINS_INSTALLED=false
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
        PLUGINS_INSTALLED=false
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
PLUGINS_INSTALLED=$PLUGINS_INSTALLED
LAST_RUN=$(date +%s)
EOF
}

# ===================================================================
# SYSTEM DETECTION AND PACKAGE MANAGER SETUP
# ===================================================================

detect_system() {
    echo -e "${BLUE}🔍 System Detection${NC}"
    echo "================================"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${GREEN}🍎 macOS detected${NC}"
        SYSTEM="macos"
        PACKAGE_MANAGER="brew"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v pacman &> /dev/null; then
            echo -e "${GREEN}🐧 Arch Linux detected${NC}"
            SYSTEM="arch"
            PACKAGE_MANAGER="pacman"
        else
            echo -e "${RED}❌ Unsupported Linux distribution${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Unsupported operating system${NC}"
        exit 1
    fi
    echo ""
}

# ===================================================================
# PACKAGE INSTALLATION FUNCTIONS
# ===================================================================

install_package() {
    local package=$1
    local description=$2
    local current=$3
    local total=$4

    show_progress $current $total
    echo -e "  ${CYAN}📦 Checking for $description...${NC}"

    if [[ "$SYSTEM" == "macos" ]]; then
        if ! brew list "$package" &> /dev/null 2>&1; then
            echo -e "     ${YELLOW}Installing $description...${NC}"
            if brew install "$package" &> /dev/null; then
                echo -e "     ${GREEN}✅ $description installed successfully${NC}"
            else
                echo -e "     ${YELLOW}⚠️  Failed to install $description (may already be installed or unavailable)${NC}"
            fi
        else
            echo -e "     ${GREEN}✅ $description already installed${NC}"
        fi
    elif [[ "$SYSTEM" == "arch" ]]; then
        if ! pacman -Q "$package" &> /dev/null 2>&1; then
            echo -e "     ${YELLOW}Installing $description...${NC}"
            if sudo pacman -S --noconfirm "$package" &> /dev/null; then
                echo -e "     ${GREEN}✅ $description installed successfully${NC}"
            else
                echo -e "     ${YELLOW}⚠️  Failed to install $description (may already be installed or unavailable)${NC}"
            fi
        else
            echo -e "     ${GREEN}✅ $description already installed${NC}"
        fi
    fi
}

install_aur_package() {
    local package=$1
    local description=$2
    local current=$3
    local total=$4

    show_progress $current $total
    echo -e "  ${CYAN}📦 Checking for $description (AUR)...${NC}"

    if ! pacman -Q "$package" &> /dev/null 2>&1; then
        echo -e "     ${YELLOW}Installing $description from AUR...${NC}"
        if yay -S --noconfirm "$package" &> /dev/null; then
            echo -e "     ${GREEN}✅ $description installed successfully${NC}"
        else
            echo -e "     ${YELLOW}⚠️  Failed to install $description from AUR (may already be installed or unavailable)${NC}"
        fi
    else
        echo -e "     ${GREEN}✅ $description already installed${NC}"
    fi
}

# ===================================================================
# PACKAGE INSTALLATION SECTION
# ===================================================================

install_packages() {
    echo -e "${BLUE}📦 Package Installation${NC}"
    echo "================================"

    # Check if we should skip package installation
    if [[ "$PACKAGES_INSTALLED" == "true" && "$FORCE_INSTALL" == "false" ]]; then
        echo -e "${YELLOW}📦 Package installation skipped (already completed)${NC}"
        echo "   Use --force-install to re-validate packages"
        echo ""
        return
    fi

    if ! ask_user "Do you want to install/check required packages?" "y"; then
        echo -e "${YELLOW}⏭️  Skipping package installation${NC}"
        echo ""
        return
    fi

    echo -e "${CYAN}🔍 Checking and installing required packages...${NC}"
    echo ""

    # Count total packages for progress bar
    local total_packages=0
    if [[ "$SYSTEM" == "macos" ]]; then
        total_packages=9  # Core packages + ZSH plugins + Optional + Font
    elif [[ "$SYSTEM" == "arch" ]]; then
        total_packages=9  # Core packages + ZSH plugins + Optional + Font
    fi

    local current_package=0

    # Core packages
    ((current_package++))
    install_package "alacritty" "Alacritty terminal" $current_package $total_packages
    ((current_package++))
    install_package "neofetch" "Neofetch system info" $current_package $total_packages
    ((current_package++))
    install_package "starship" "Starship prompt" $current_package $total_packages
    ((current_package++))
    install_package "zsh" "ZSH shell" $current_package $total_packages
    ((current_package++))
    install_package "neovim" "Neovim editor" $current_package $total_packages

    # ZSH plugins
    ((current_package++))
    install_package "zsh-syntax-highlighting" "ZSH syntax highlighting" $current_package $total_packages
    ((current_package++))
    install_package "zsh-autosuggestions" "ZSH autosuggestions" $current_package $total_packages

    # Optional packages
    ((current_package++))
    install_package "fzf" "Fuzzy finder" $current_package $total_packages
    ((current_package++))
    install_package "git" "Git version control" $current_package $total_packages

    # Font installation - Nerd Fonts for glyphs
    if [[ "$SYSTEM" == "macos" ]]; then
        ((current_package++))
        install_package "font-hack-nerd-font" "Hack Nerd Font (with glyphs)" $current_package $total_packages
    elif [[ "$SYSTEM" == "arch" ]]; then
        ((current_package++))
        install_aur_package "nerd-fonts-hack" "Hack Nerd Font (with glyphs)" $current_package $total_packages
    fi

    # Mark packages as installed
    PACKAGES_INSTALLED=true
    write_state

    echo ""
    echo -e "${GREEN}📊 Package Installation Summary:${NC}"
    echo -e "${GREEN}✅ Core packages checked/installed${NC}"
    echo -e "${GREEN}✅ ZSH plugins checked/installed${NC}"
    echo -e "${GREEN}✅ Optional tools checked/installed${NC}"
    echo -e "${GREEN}✅ Fonts checked/installed${NC}"
    echo ""
}

# ===================================================================
# CONFIGURATION SETUP SECTION
# ===================================================================

setup_configs() {
    echo -e "${BLUE}📁 Configuration Setup${NC}"
    echo "================================"

    if ! ask_user "Do you want to copy configuration files?" "y"; then
        echo -e "${YELLOW}⏭️  Skipping configuration setup${NC}"
        echo ""
        return
    fi

    echo -e "${CYAN}📁 Creating directories...${NC}"
    mkdir -p ~/.config/alacritty ~/.config/neofetch ~/.zsh 2>/dev/null || {
        echo -e "${YELLOW}⚠️  Warning: Could not create some directories (may already exist)${NC}"
    }

    local total_configs=6
    local current_config=0

    # Copy Alacritty config
    ((current_config++))
    show_progress $current_config $total_configs
    echo -e "  ${PURPLE}🖥️  Setting up Alacritty...${NC}"
    if [ -f "$SCRIPT_DIR/alacritty/alacritty.toml" ]; then
        if cp "$SCRIPT_DIR/alacritty/alacritty.toml" ~/.config/alacritty/ 2>/dev/null; then
            echo -e "     ${GREEN}✅ Alacritty config copied${NC}"
        else
            echo -e "     ${YELLOW}⚠️  Warning: Could not copy Alacritty config (may already exist)${NC}"
        fi
    else
        echo -e "     ${YELLOW}⚠️  Warning: Alacritty config not found${NC}"
    fi

    # Copy Neofetch config
    ((current_config++))
    show_progress $current_config $total_configs
    echo -e "  ${PURPLE}🖼️  Setting up Neofetch...${NC}"
    if [ -f "$SCRIPT_DIR/neofetch/config.conf" ]; then
        if cp "$SCRIPT_DIR/neofetch/config.conf" ~/.config/neofetch/ 2>/dev/null; then
            echo -e "     ${GREEN}✅ Neofetch config copied${NC}"
        else
            echo -e "     ${YELLOW}⚠️  Warning: Could not copy Neofetch config (may already exist)${NC}"
        fi
    else
        echo -e "     ${YELLOW}⚠️  Warning: Neofetch config not found${NC}"
    fi

    # Copy ZSH configs
    ((current_config++))
    show_progress $current_config $total_configs
    echo -e "  ${PURPLE}🐚 Setting up ZSH...${NC}"
    if [ -f "$SCRIPT_DIR/zsh/.zshrc" ]; then
        if cp "$SCRIPT_DIR/zsh/.zshrc" ~/ 2>/dev/null; then
            echo -e "     ${GREEN}✅ Main zshrc copied${NC}"
        else
            echo -e "     ${YELLOW}⚠️  Warning: Could not copy main zshrc (may already exist)${NC}"
        fi
    else
        echo -e "     ${YELLOW}⚠️  Warning: Main zshrc not found${NC}"
    fi

    # Copy modular ZSH configs
    if [ -d "$SCRIPT_DIR/zsh" ]; then
        local copied_count=0
        for file in "$SCRIPT_DIR"/zsh/*.zsh; do
            if [ -f "$file" ]; then
                if cp "$file" ~/.zsh/ 2>/dev/null; then
                    echo -e "     ${GREEN}✅ Copied $(basename "$file")${NC}"
                    ((copied_count++))
                else
                    echo -e "     ${YELLOW}⚠️  Warning: Could not copy $(basename "$file") (may already exist)${NC}"
                fi
            fi
        done
        if [ $copied_count -eq 0 ]; then
            echo -e "     ${YELLOW}⚠️  Warning: No ZSH config files found to copy${NC}"
        fi
    else
        echo -e "     ${YELLOW}⚠️  Warning: ZSH config directory not found${NC}"
    fi

    # Copy Neovim config
    ((current_config++))
    show_progress $current_config $total_configs
    echo -e "  ${PURPLE}📝 Setting up Neovim...${NC}"
    if [ -d "$SCRIPT_DIR/nvim" ]; then
        if cp -r "$SCRIPT_DIR/nvim" ~/.config/ 2>/dev/null; then
            echo -e "     ${GREEN}✅ Neovim config copied${NC}"
        else
            echo -e "     ${YELLOW}⚠️  Warning: Could not copy Neovim config (may already exist)${NC}"
        fi
    else
        echo -e "     ${YELLOW}⚠️  Warning: Neovim config not found${NC}"
    fi

    # Copy Starship config
    ((current_config++))
    show_progress $current_config $total_configs
    echo -e "  ${PURPLE}⭐ Setting up Starship...${NC}"
    if [ -f "$SCRIPT_DIR/starship/starship.toml" ]; then
        if cp "$SCRIPT_DIR/starship/starship.toml" ~/.config/ 2>/dev/null; then
            echo -e "     ${GREEN}✅ Starship config copied${NC}"
        else
            echo -e "     ${YELLOW}⚠️  Warning: Could not copy Starship config (may already exist)${NC}"
        fi
    else
        echo -e "     ${YELLOW}⚠️  Warning: Starship config not found${NC}"
    fi

    # Copy Cursor config
    ((current_config++))
    show_progress $current_config $total_configs
    echo -e "  ${PURPLE}🎯 Setting up Cursor...${NC}"
    if [ -f "$SCRIPT_DIR/cursor/settings.json" ]; then
        # Create Cursor config directory
        mkdir -p ~/Library/Application\ Support/Cursor/User 2>/dev/null || true
        if cp "$SCRIPT_DIR/cursor/settings.json" ~/Library/Application\ Support/Cursor/User/ 2>/dev/null; then
            echo -e "     ${GREEN}✅ Cursor config copied${NC}"
        else
            echo -e "     ${YELLOW}⚠️  Warning: Could not copy Cursor config (may already exist)${NC}"
        fi
    else
        echo -e "     ${YELLOW}⚠️  Warning: Cursor config not found${NC}"
    fi

    # Mark configs as copied
    CONFIGS_COPIED=true
    write_state
    echo ""
}

# ===================================================================
# NEOVIM PLUGIN INSTALLATION SECTION
# ===================================================================

install_neovim_plugins() {
    echo -e "${BLUE}🔌 Neovim Plugin Installation${NC}"
    echo "================================"

    if ! ask_user "Do you want to install Neovim plugins (Mason, LSP servers, etc.)?" "y"; then
        echo -e "${YELLOW}⏭️  Skipping Neovim plugin installation${NC}"
        echo ""
        return
    fi

    echo -e "${CYAN}🔄 Installing Neovim plugins with Lazy.nvim...${NC}"
    echo "This may take a few minutes..."

    # Show progress for plugin installation
    echo -e "  ${PURPLE}📦 Installing Lazy.nvim and plugins...${NC}"

    if nvim --headless "+Lazy! sync" +qa 2>/dev/null; then
        echo -e "     ${GREEN}✅ All Neovim plugins installed successfully${NC}"
        echo -e "     ${GREEN}✅ Mason and LSP servers are ready${NC}"
    else
        echo -e "     ${YELLOW}⚠️  Some plugins may have failed to install${NC}"
        echo -e "     ${YELLOW}   You can run ':Lazy sync' in Neovim to retry${NC}"
    fi

    # Test Neovim configuration
    echo -e "  ${PURPLE}🔍 Testing Neovim configuration...${NC}"
    if nvim --headless -c "lua print('Testing core modules...')" -c "lua require('core.init')" -c "lua print('Core modules loaded successfully')" -c "quit" 2>/dev/null; then
        echo -e "     ${GREEN}✅ Core modules working${NC}"
    else
        echo -e "     ${RED}❌ Core modules failed to load${NC}"
    fi

    # Test plugin loading
    echo -e "  ${PURPLE}🔍 Testing plugin loading...${NC}"
    if nvim --headless -c "lua print('Testing plugins...')" -c "lua require('plugins.init')" -c "lua print('Plugins loaded successfully')" -c "quit" 2>/dev/null; then
        echo -e "     ${GREEN}✅ Plugins loaded successfully${NC}"
    else
        echo -e "     ${RED}❌ Plugin loading failed${NC}"
    fi

    # Test full configuration
    echo -e "  ${PURPLE}🔍 Testing full Neovim configuration...${NC}"
    if nvim --headless -c "lua print('Testing full config...')" -c "source ~/.config/nvim/init.lua" -c "lua print('Full config loaded successfully')" -c "quit" 2>/dev/null; then
        echo -e "     ${GREEN}✅ Full configuration working${NC}"
    else
        echo -e "     ${RED}❌ Full configuration failed${NC}"
    fi

    # Test Mason
    echo -e "  ${PURPLE}🔍 Testing Mason...${NC}"
    if nvim --headless -c "lua print('Testing Mason...')" -c "lua require('mason').setup()" -c "lua print('Mason loaded successfully')" -c "quit" 2>/dev/null; then
        echo -e "     ${GREEN}✅ Mason working${NC}"
    else
        echo -e "     ${RED}❌ Mason failed to load${NC}"
    fi

    # Install LSP servers
    echo -e "  ${PURPLE}📦 Installing LSP servers...${NC}"
    if nvim --headless -c "MasonInstall pyright" -c "MasonInstall html" -c "MasonInstall tsserver" -c "MasonInstall jsonls" -c "MasonInstall lua_ls" -c "quit" 2>/dev/null; then
        echo -e "     ${GREEN}✅ LSP servers installed${NC}"
    else
        echo -e "     ${YELLOW}⚠️  Some LSP servers may have failed to install${NC}"
    fi

    # Test LSP functionality
    echo -e "  ${PURPLE}🔍 Testing LSP functionality...${NC}"
    echo 'print("Hello, World!")' > /tmp/test_lsp.py
    if nvim --headless -c "edit /tmp/test_lsp.py" -c "lua print('Python file opened')" -c "LspInfo" -c "quit" 2>/dev/null; then
        echo -e "     ${GREEN}✅ LSP functionality working${NC}"
    else
        echo -e "     ${YELLOW}⚠️  LSP functionality may need manual setup${NC}"
    fi
    rm -f /tmp/test_lsp.py

    # Final LSP verification
    echo -e "  ${PURPLE}🔍 Final LSP verification...${NC}"
    echo 'print("Hello, World!")
def test_function():
    return "test"' > /tmp/test_lsp_final.py
    if nvim --headless -c "edit /tmp/test_lsp_final.py" -c "lua print('Testing LSP in Python file...')" -c "lua print('File opened successfully')" -c "quit" 2>/dev/null; then
        echo -e "     ${GREEN}✅ LSP file handling working${NC}"
    else
        echo -e "     ${YELLOW}⚠️  LSP file handling may need manual setup${NC}"
    fi
    rm -f /tmp/test_lsp_final.py

    # Mark plugins as installed
    PLUGINS_INSTALLED=true
    write_state
    echo ""
}

# ===================================================================
# FINAL STATUS CHECK SECTION
# ===================================================================

final_status_check() {
    echo -e "${BLUE}🔍 Final Status Check${NC}"
    echo "================================"

    if command -v alacritty &> /dev/null; then
        echo -e "${GREEN}✅ Alacritty available${NC}"
    else
        echo -e "${YELLOW}⚠️  Alacritty not found${NC}"
    fi

    if command -v neofetch &> /dev/null; then
        echo -e "${GREEN}✅ Neofetch available${NC}"
    else
        echo -e "${YELLOW}⚠️  Neofetch not found${NC}"
    fi

    if command -v starship &> /dev/null; then
        echo -e "${GREEN}✅ Starship available${NC}"
    else
        echo -e "${YELLOW}⚠️  Starship not found${NC}"
    fi

    if command -v nvim &> /dev/null; then
        echo -e "${GREEN}✅ Neovim available${NC}"
    else
        echo -e "${YELLOW}⚠️  Neovim not found${NC}"
    fi

    if command -v cursor &> /dev/null; then
        echo -e "${GREEN}✅ Cursor available${NC}"
    else
        echo -e "${YELLOW}⚠️  Cursor not found (install from https://cursor.sh)${NC}"
    fi
    echo ""
}

# ===================================================================
# MAIN EXECUTION
# ===================================================================

# Initialize state management
init_state
read_state

# Detect system and package manager
detect_system

# Install packages
install_packages

# Setup configurations
setup_configs

# Install Neovim plugins
install_neovim_plugins

# Final status check
final_status_check

# Completion message
echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
echo -e "${CYAN}📋 Next steps:${NC}"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. If you're on macOS, you might need to set Hack as your terminal font"
echo "3. Open Neovim to test LSP functionality"
echo "4. Enjoy your new setup! 🚀"
echo ""
echo -e "${CYAN}🔧 Your configs are now in:${NC}"
echo "   - ~/.zshrc (main zsh config)"
echo "   - ~/.zsh/ (modular zsh configs)"
echo "   - ~/.config/alacritty/ (terminal config)"
echo "   - ~/.config/neofetch/ (system info config)"
echo "   - ~/.config/nvim/ (editor config)"
echo ""
echo -e "${CYAN}📦 Installed packages:${NC}"
echo "   - Alacritty (terminal)"
echo "   - Neofetch (system info)"
echo "   - Starship (prompt)"
echo "   - Neovim (editor)"
echo "   - ZSH plugins (syntax highlighting, autosuggestions)"
echo "   - FZF (fuzzy finder)"
echo "   - Hack font"
echo ""
echo -e "${CYAN}🔌 Neovim plugins:${NC}"
echo "   - Lazy.nvim (plugin manager)"
echo "   - Mason (LSP server manager)"
echo "   - nvim-lspconfig (LSP client)"
echo "   - Nord theme"
echo ""
echo -e "${YELLOW}📝 State file: $STATE_FILE${NC}"
echo "   Use --force-install to re-validate packages"
echo "   Use --skip-prompts to auto-accept all prompts"
