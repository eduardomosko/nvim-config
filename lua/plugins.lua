-- Auto install packer if not found
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	vim.api.nvim_command "packadd packer.nvim"
end


return require('packer').startup (function (use)
	-- Packer
	use 'wbthomason/packer.nvim'

	-- LSP
	use 'neovim/nvim-lspconfig'
	use 'kabouzeid/nvim-lspinstall'

	-- 42
	use { 'vinicius507/norme.nvim', branch = 'dev',
		requires = {{'nvim-lua/plenary.nvim'}, {'jose-elias-alvarez/null-ls.nvim'}}
	}
	use 'eduardomosko/header42.nvim'

	-- AutoComplete
	--use 'hrsh7th/nvim-compe'

	-- NerdTree
	use 'preservim/nerdtree'
	use 'Xuyuanp/nerdtree-git-plugin'

	-- Syntax Highlighting
	--use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
	--use 'gianarb/vim-flux'
	--use 'tpope/vim-markdown'

	-- Telescope
	use {'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}

	-- Colorschemes
	use 'joshdick/onedark.vim'
	use 'morhetz/gruvbox'
	use 'arzg/vim-colors-xcode'
	use 'sainnhe/sonokai'
	use 'shaunsingh/nord.nvim'
	use 'pbrisbin/vim-colors-off'
	use 't184256/vim-boring'
	use 'plan9-for-vimspace/acme-colors'

	-- Git
	use 'airblade/vim-gitgutter'
	use 'tpope/vim-fugitive'

end)
