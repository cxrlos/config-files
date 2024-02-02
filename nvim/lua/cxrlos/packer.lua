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
	use {	-- GitHub Copilot: AI pair programming
		"github/copilot.vim", branch = "release" 
	}
end)