# 🐚 ZSH Configuration

Modular ZSH setup with Starship prompt and modern features.

## ✨ Features

- **Starship Prompt**: Fast, customizable prompt
- **Modular Config**: Organized into separate files
- **Git Integration**: Beautiful git log aliases
- **Auto-completion**: Smart substring matching
- **Cross-platform**: Works on macOS and Linux

## 📁 Structure

```
zsh/
├── .zshrc              # Main configuration
├── aliases.zsh         # All aliases
├── functions.zsh       # Custom functions
├── vim-mode.zsh        # Vim keybindings
├── plugins.zsh         # Plugin configuration
└── env.zsh            # Environment variables
```

## 🎯 Key Features

### Aliases
- **Git**: `gst`, `ga`, `gc`, `gp`, `gl`, `gco`, `gcb`
- **Beautiful Git Log**: `glol`, `glols`, `glola` with Nord colors
- **Quick Branches**: `gbf`, `gbb`, `gbd`, `gbs`, `gbr`, `gbt`, `gbc`
- **System**: `ll`, `la`, `l`, `..`, `...`, `....`

### Functions
- **`gconb`**: Create conventional commit branches
- **Usage**: `gconb <type> <description>`
- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### Starship Prompt
- **Theme**: Nord colors throughout
- **Modules**: Git, Python, Node.js, Rust, Docker
- **Cloud**: Shows only at root directory
- **Performance**: Fast rendering

## 🔧 Setup

The setup script copies files to:
- `~/.zshrc` (main config)
- `~/.zsh/` (modular configs)

## 📚 Documentation

- [Starship Documentation](https://starship.rs/)
- [ZSH Documentation](https://zsh.sourceforge.io/)
- [Oh My Zsh](https://ohmyz.sh/) (for reference)

## 🎯 Tips

- Run `source ~/.zshrc` after changes
- Use `gconb --help` for branch creation help
- Starship config is in `~/.config/starship.toml`
- New tabs start in home directory
