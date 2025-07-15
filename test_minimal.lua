-- Minimal test configuration
vim.g.mapleader = " "

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

-- Minimal plugins
local plugins = {
    {
        "arcticicestudio/nord-vim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme nord")
        end,
    },
}

-- Initialize lazy.nvim
local ok, lazy = pcall(require, "lazy")
if ok then
    lazy.setup(plugins)
else
    vim.notify("Failed to initialize lazy.nvim", vim.log.levels.ERROR)
end

print("Minimal config loaded successfully")
