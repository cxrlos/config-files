-- ===================================================================
--                        MODERN NVIM CONFIGURATION
-- ===================================================================
-- Clean, modular Neovim setup optimized for development
-- Author: cxrlos
-- Features: Excellent remaps, Cursor-compatible, modular design
-- ===================================================================

-- ===================================================================
-- MAIN ENTRY POINT
-- ===================================================================

-- Set up runtime path to include lua directory
vim.opt.runtimepath:append(vim.fn.stdpath("config") .. "/lua")

-- Load core configuration
require("core.init")

-- ===================================================================
-- END OF CONFIGURATION
-- ===================================================================
