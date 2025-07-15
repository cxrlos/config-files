-- ===================================================================
--                        CORE SETTINGS
-- ===================================================================
-- Essential Neovim settings optimized for development
-- Cursor-compatible configuration
-- ===================================================================

-- ===================================================================
-- EDITOR BEHAVIOR
-- ===================================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Text display
vim.opt.wrap = false
vim.opt.linebreak = true

-- ===================================================================
-- SEARCH AND NAVIGATION
-- ===================================================================

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ===================================================================
-- PERFORMANCE AND FILE HANDLING
-- ===================================================================

-- File handling
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Update time for better performance
vim.opt.updatetime = 50

-- ===================================================================
-- VISUAL APPEARANCE
-- ===================================================================

-- Colors and display
vim.opt.termguicolors = true
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Mouse support
vim.opt.mouse = "a"

-- ===================================================================
-- SYNTAX AND HIGHLIGHTING
-- ===================================================================

-- Enable syntax highlighting
vim.cmd("syntax on")

-- ===================================================================
-- END OF SETTINGS
-- ===================================================================
