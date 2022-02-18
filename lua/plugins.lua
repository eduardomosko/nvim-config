-- Auto install packer if not found
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.api.nvim_command("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	vim.api.nvim_command "packadd packer.nvim"
end


return require('packer').startup (function (use)
	-- Packer
	use 'wbthomason/packer.nvim'

	-- NerdTree
	use 'preservim/nerdtree'
	use 'Xuyuanp/nerdtree-git-plugin'

	-- LspConfig
	use 'neovim/nvim-lspconfig'

	-- Syntax Highlighting
	use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

	-- Telescope
	use {'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}

	-- Colorschemes
	use 'pbrisbin/vim-colors-off'
	use 'owickstrom/vim-colors-paramount'
	use 'owickstrom/vim-colors-paramount'
	use 'joshdick/onedark.vim'
	use 'morhetz/gruvbox'

	-- Git
	use 'airblade/vim-gitgutter'
	use 'tpope/vim-fugitive'
end)
