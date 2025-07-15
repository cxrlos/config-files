-- ===================================================================
--                        CORE PLUGINS
-- ===================================================================
-- Essential plugins for development and productivity
-- ===================================================================

return {
    -- Plugin Management
    {
        "folke/lazy.nvim",
        version = "*",
    },

    -- Colorscheme
    {
        "arcticicestudio/nord-vim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme nord")
        end,
    },

    -- LSP Management (Basic)
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
        priority = 1000,
    },

    -- Language Support
    {
        "psf/black",
        ft = "python",
    },
}
