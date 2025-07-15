-- ===================================================================
--                        CORE KEYMAPS
-- ===================================================================
-- Excellent remaps optimized for development
-- Cursor-compatible keybindings
-- ===================================================================

-- ===================================================================
-- NAVIGATION AND WINDOW MANAGEMENT
-- ===================================================================

-- File explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- ===================================================================
-- TEXT MANIPULATION
-- ===================================================================

-- Move code in visual blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- ===================================================================
-- SEARCH AND SCROLLING
-- ===================================================================

-- Maintain cursor in middle while scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Maintain cursor in middle while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- ===================================================================
-- CLIPBOARD AND YANKING
-- ===================================================================

-- System clipboard integration
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- ===================================================================
-- FILE AND BUFFER OPERATIONS
-- ===================================================================

-- Quick save and quit
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Quick file operations
vim.keymap.set("n", "<leader>e", ":e ")
vim.keymap.set("n", "<leader>v", ":vsplit ")
vim.keymap.set("n", "<leader>s", ":split ")

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bn<CR>")
vim.keymap.set("n", "<leader>bp", ":bp<CR>")
vim.keymap.set("n", "<leader>bd", ":bd<CR>")

-- ===================================================================
-- UTILITY AND SAFETY
-- ===================================================================

-- Disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- ===================================================================
-- END OF KEYMAPS
-- ===================================================================
