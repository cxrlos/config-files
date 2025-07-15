# 🚀 Config Files

A modern, cross-platform terminal and development environment configuration.

## ✨ Features

- **Alacritty Terminal**: Nord theme with transparency and smooth scrolling
- **ZSH Shell**: Modular configuration with Starship prompt
- **Neovim**: Basic Lua configuration (expandable)
- **Cursor Editor**: Optimized for Python/Scala development
- **Neofetch**: Custom system info display
- **Cross-platform**: Works on macOS and Arch Linux

## 🛠️ Quick Setup

```bash
# Clone and run setup
git clone <your-repo>
cd config-files
./setup.sh
```

## 📁 Structure

```
config-files/
├── alacritty/     # Terminal configuration
├── cursor/        # Cursor editor settings
├── neofetch/      # System info display
├── nvim/          # Basic Neovim config
├── old_nvim/      # Previous Neovim config
├── zsh/           # Modular ZSH configuration
└── setup.sh       # Automated setup script
```

## 🎨 Theme

- **Colors**: Nord color scheme
- **Font**: Hack Nerd Font
- **Style**: Modern, minimal, glass-like effects

## 📚 Documentation

Each folder contains its own README with specific details:
- [Alacritty](alacritty/README.md) - Terminal configuration
- [ZSH](zsh/README.md) - Shell setup and aliases
- [Neovim](nvim/README.md) - Editor configuration
- [Cursor](cursor/README.md) - Editor settings
- [Neofetch](neofetch/README.md) - System info display

## 🔧 Customization

- Edit individual config files to customize
- Run `./setup.sh --force-install` to re-validate packages
- Check `~/.config-setup-state` for installation status

## 📦 Requirements

- macOS or Arch Linux
- Homebrew (macOS) or pacman (Arch)
- Git for version control

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on both platforms
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details.
