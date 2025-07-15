-- ===================================================================
--                        BASIC NVIM CONFIGURATION
-- ===================================================================
-- Minimal Neovim setup with essential features
-- Author: cxrlos
-- Features: Basic settings, keymaps, colorscheme
-- ===================================================================

-- ===================================================================
-- BASIC SETTINGS
-- ===================================================================

-- Set leader key
vim.g.mapleader = " "

-- Enable line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse
vim.o.mouse = "a"

-- Enable syntax highlighting
vim.cmd("syntax on")

-- Set colorscheme
vim.cmd("colorscheme nord")

-- ===================================================================
-- KEYMAPS
-- ===================================================================

-- Quick save
vim.keymap.set("n", "<leader>w", ":w<CR>")

-- Quick quit
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- ===================================================================
-- END OF BASIC CONFIG
-- ===================================================================
