-- ===================================================================
--                        PLUGIN MANAGEMENT
-- ===================================================================
-- Centralized plugin management using lazy.nvim
-- ===================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin specifications with error handling
local plugins = {}

-- Core plugins
local ok, core_plugins = pcall(require, "plugins.core")
if ok then
    for _, plugin in ipairs(core_plugins) do
        table.insert(plugins, plugin)
    end
else
    vim.notify("Failed to load core plugins", vim.log.levels.ERROR)
end

-- Initialize lazy.nvim with error handling
local ok, lazy = pcall(require, "lazy")
if ok then
    lazy.setup(plugins)
else
    vim.notify("Failed to initialize lazy.nvim", vim.log.levels.ERROR)
end

-- ===================================================================
-- END OF PLUGIN MANAGEMENT
-- ===================================================================
