-- Only required if you have packer configured as `opt`
vim.cmd.packadd("packer.nvim")

return require("packer").startup(function(use)
    -- Packer can manage itself
    use "wbthomason/packer.nvim"

    use {	-- Telescope: Fuzzy finder
    "nvim-telescope/telescope.nvim", tag = "0.1.5",
    requires = { {"nvim-lua/plenary.nvim"} }
}
use ({	-- Rose Pine: Color scheme
"rose-pine/neovim",
as = "rose-pine",
config = function()
    vim.cmd("colorscheme rose-pine")
end
    })
    use (	-- Treesitter: Syntax highlighting
    "nvim-treesitter/nvim-treesitter", 
    {run = ":TSUpdate"}
    )
    use (	-- Treesitter Playground: Treesitter playground
    "nvim-treesitter/playground"
    )
    use (	-- Harpoon: Quick file navigation
    "theprimeagen/harpoon"
    )
    use (	-- UndoTree: Visualize undo history
    "mbbill/undotree"
    )
    use (	-- Vim-Fugitive: Git wrapper
    "tpope/vim-fugitive"
    )
    use (  -- Git Signs: Git signs
    'mfussenegger/nvim-dap'
    )
    use {	-- LSP Zero: LSP configuration
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-nvim-lua'},

        -- Snippets
        {'L3MON4D3/LuaSnip'},
        {'rafamadriz/friendly-snippets'},

        use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }}),

        }
    }
    use {	-- GitHub Copilot: AI pair programming
        "github/copilot.vim", branch = "release"
    }
end)
