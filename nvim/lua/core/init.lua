-- ===================================================================
--                        CORE INITIALIZATION
-- ===================================================================
-- Main entry point for core Neovim configuration
-- Loads all core modules in the correct order
-- ===================================================================

-- Set leader key early
vim.g.mapleader = " "

-- Load core modules in dependency order
require("core.settings")      -- Basic editor settings
require("core.keymaps")       -- Key mappings
require("core.autocmds")      -- Auto commands
require("core.plugins")       -- Plugin management

-- ===================================================================
-- END OF CORE INITIALIZATION
-- ===================================================================
