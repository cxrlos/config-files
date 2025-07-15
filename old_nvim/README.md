# 📝 Old Neovim Configuration

Previous Neovim setup with plugins and advanced features.

## 📋 Contents

This folder contains the previous Neovim configuration that was replaced with a basic setup.

### Features (Previous)
- **Packer**: Plugin manager
- **LSP**: Language Server Protocol
- **Telescope**: Fuzzy finder
- **Treesitter**: Syntax highlighting
- **Harpoon**: File navigation
- **Fugitive**: Git integration
- **Undotree**: Undo history
- **Color Schemes**: Custom colors

## 📁 Structure

```
old_nvim/
├── init.lua              # Main configuration
├── lua/cxrlos/          # Custom modules
│   ├── init.lua         # Module initialization
│   ├── packer.lua       # Plugin management
│   ├── remap.lua        # Key mappings
│   └── set.lua          # Settings
├── after/plugin/        # Plugin configurations
│   ├── colors.lua       # Color schemes
│   ├── fugitive.lua     # Git integration
│   ├── harpoon.lua      # File navigation
│   ├── lsp.lua          # Language servers
│   ├── telescope.lua    # Fuzzy finder
│   ├── treesitter.lua   # Syntax highlighting
│   └── undotree.lua     # Undo history
└── old/                 # Legacy configs
    └── init.vim         # Vimscript config
```

## 🔄 Migration

To restore this configuration:
1. Copy `old_nvim/` to `~/.config/nvim/`
2. Install Packer: `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`
3. Run `:PackerSync` in Neovim

## 📚 Documentation

- [Packer Documentation](https://github.com/wbthomason/packer.nvim)
- [LSP Setup](https://neovim.io/doc/user/lsp.html)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)

## ⚠️ Note

This is the previous configuration. The current setup is minimal and expandable.
