# Clean Neovim Configuration

A minimal, well-organized Neovim setup focused on essential functionality and clean code organization.

## Features

- **Minimal Design**: Clean, focused configuration without unnecessary complexity
- **Modular Structure**: Well-organized modules with clear separation of concerns
- **Nord Theme**: Beautiful Nord color scheme integration
- **Essential Plugins**: Only the plugins you actually need
- **Cursor Compatible**: Optimized for use with Cursor editor

## Structure

```
nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── core/               # Core Neovim configuration
│   │   ├── init.lua        # Core initialization
│   │   ├── settings.lua    # Editor settings
│   │   ├── keymaps.lua     # Key mappings
│   │   ├── autocmds.lua    # Auto commands
│   │   └── plugins.lua     # Plugin loader
│   └── plugins/            # Plugin management
│       ├── init.lua        # Plugin bootstrap
│       └── core.lua        # Core plugins
```

## Core Modules

### `core/init.lua`
Main entry point for core configuration. Loads all core modules in the correct dependency order.

### `core/settings.lua`
Essential Neovim settings organized by category:
- **Editor Behavior**: Line numbers, indentation, text display
- **Search and Navigation**: Search settings and behavior
- **Performance and File Handling**: File management and performance
- **Visual Appearance**: Colors, display, mouse support
- **Syntax and Highlighting**: Syntax highlighting

### `core/keymaps.lua`
Key mappings organized by functionality:
- **Navigation and Window Management**: File explorer, split navigation
- **Text Manipulation**: Visual block movement
- **Search and Scrolling**: Enhanced search and scroll behavior
- **Clipboard and Yanking**: System clipboard integration
- **File and Buffer Operations**: Quick file and buffer management
- **Utility and Safety**: Safety features and utilities

### `core/autocmds.lua`
Auto commands organized by purpose:
- **Filetype-Specific Settings**: Language-specific configurations
- **Buffer and Editor Behavior**: Buffer-level behaviors and enhancements

## Plugin System

### `plugins/init.lua`
Centralized plugin management using lazy.nvim. Loads all core plugins.

### `plugins/core.lua`
Essential development plugins:
- **Lazy.nvim**: Plugin manager
- **Nord Theme**: Beautiful color scheme
- **Mason**: Basic LSP server management (ready for future LSP setup)
- **Black**: Python formatter

## Key Features

### Navigation
- `<leader>pv`: File explorer
- `<C-h/j/k/l>`: Window navigation
- `<leader>e/v/s`: Quick file operations
- `<leader>bn/bp/bd`: Buffer management

### Text Manipulation
- `J/K` in visual mode: Move lines up/down
- `<leader>y/Y`: System clipboard yank
- `<C-d/u>`: Smart scrolling

### Search Enhancement
- `n/N`: Keep cursor centered
- Enhanced search with smart case

## Installation

1. Clone this configuration to `~/.config/nvim/`
2. Install required system dependencies:
   - Git (for lazy.nvim)
3. Start Neovim - plugins will install automatically

## Customization

### Adding New Plugins
1. Add to `plugins/core.lua`
2. Configure in the plugin's config function
3. Restart Neovim

### Modifying Keymaps
Edit `core/keymaps.lua` and restart Neovim.

### Adding LSP Support (Future)
When ready to add LSP:
1. Add LSP servers to `plugins/core.lua`
2. Configure LSP settings in a new `lsp/` directory
3. Update this README

## Compatibility

- **Cursor Editor**: Fully compatible with Cursor's Neovim integration
- **Terminal**: Works with any terminal emulator
- **Operating Systems**: macOS, Linux, Windows
- **Neovim Version**: 0.8.0+

## Performance

- **Fast Startup**: Minimal core configuration
- **Lazy Loading**: Plugins load only when needed
- **Memory Efficient**: Clean, minimal setup

## Design Principles

1. **Simplicity**: Only essential functionality
2. **Modularity**: Clear separation of concerns
3. **Maintainability**: Easy to understand and modify
4. **Extensibility**: Ready for future additions

## Contributing

This configuration is designed to be easily extensible. Follow the modular structure when adding new features:

1. **Core functionality**: Add to appropriate `core/` file
2. **Plugins**: Add to `plugins/core.lua`
3. **Documentation**: Update this README

## License

MIT License - feel free to use and modify as needed.
