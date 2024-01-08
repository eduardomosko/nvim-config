local bootstrapped = (function()
	-- Auto install packer if not found
	local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	
	if not vim.loop.fs_stat(install_path) then
		vim.fn.system {'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path}
		vim.cmd 'packadd packer.nvim'
		return true
	end

	return false
end)()

return require('packer').startup(function (use)
	-- Packer
	use 'wbthomason/packer.nvim'

	-- NerdTree
	-- TODO: install lua-tree or something like that
	use 'preservim/nerdtree'
	use 'Xuyuanp/nerdtree-git-plugin'

	-- LspConfig
	use 'neovim/nvim-lspconfig'

	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'

	-- Syntax Highlighting
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	use 'delphinus/vim-firestore'
    use "vrischmann/tree-sitter-templ"

	-- Telescope
	use {'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}

	-- Auto save
	use 'pocco81/auto-save.nvim'

	-- Surround
	use {"kylechui/nvim-surround", tag = "*"}

	-- Todo
	use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}

	-- Colorschemes
	use 'morhetz/gruvbox'
	use 'pbrisbin/vim-colors-off'
	use {'catppuccin/nvim', as = 'catppuccin'}
	use {'monsonjeremy/onedark.nvim', branch = 'treesitter'}

	-- Git
	use 'airblade/vim-gitgutter'
	use 'tpope/vim-fugitive'

	-- Terminal
	use 'akinsho/toggleterm.nvim'

	if bootstrapped then
		require('packer').sync()
	end
end)
