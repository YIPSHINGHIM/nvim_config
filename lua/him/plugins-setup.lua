-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- add list of plugins to install
return packer.startup(function(use)
	-- packer can manage itself
	use("wbthomason/packer.nvim")

	-- lua functions that many plugins use
	use("nvim-lua/plenary.nvim")

	-- One Dark Pro colour Scheme
	use("olimorris/onedarkpro.nvim")

	-- Vim Tmux Navigator (tmux & split window navigation)
	use("christoomey/vim-tmux-navigator")

	-- maximizes and restores current window
	use("szw/vim-maximizer")

	-- essential plugins

	-- add, delete, change surroundings (it's awesome)
	use("tpope/vim-surround")

	-- replace with register contents using motion (gr + motion)
	use("inkarkat/vim-ReplaceWithRegister")

	-- commenting with gc
	use("numToStr/Comment.nvim")

	-- vs-code like icons
	use("nvim-tree/nvim-web-devicons")

	-- statusline
	use("nvim-lualine/lualine.nvim")

	-- fuzzy finding w/ telescope
	-- dependency for better sorting performance
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- fuzzy finder
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" })

	-- telescope file browser
	use("nvim-telescope/telescope-file-browser.nvim")

	-- harpoon
	use("ThePrimeagen/harpoon")

	-- tab bar plugins
	use({ "romgrk/barbar.nvim", requires = "nvim-web-devicons" })

	-- Undotree
	use("mbbill/undotree")

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths
	use("uga-rosa/cmp-dictionary") -- dictionary source for nvim-cmp
	use("f3fora/cmp-spell") -- spell source for nvim-cmp
	use("hrsh7th/cmp-calc") -- calculator source for nvim-cmp
	use("kdheepak/cmp-latex-symbols") --latex source for nvim-cmp

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

	-- configuring lsp servers
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		requires = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	}) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	-- intellisense with lsp
	-- use({ "neoclide/coc.nvim", branch = "release" })

	-- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-fugitive")

	use("norcalli/nvim-colorizer.lua")
	use("folke/zen-mode.nvim")
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})

	-- python env check
	-- use("plytophogy/vim-virtualenv")
	-- use("PieterjanMontens/vim-pipenv")

	-- todo-comments
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	-- obsidian extension
	-- use("epwalsh/obsidian.nvim")

	-- python jupyter notebook
	use({ "dccsillag/magma-nvim", run = ":UpdateRemotePlugins" })

	if packer_bootstrap then
		require("him.plugins.comment")
		require("packer").sync()
	end
end)
