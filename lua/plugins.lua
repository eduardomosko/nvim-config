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
	use 'delphinus/vim-firestore'

	-- Telescope
	use {'nvim-telescope/telescope.nvim',
		requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
	}

	-- Auto save
	use 'pocco81/auto-save.nvim'

	-- Todo
	use {"folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim"}

	-- Colorschemes
	use 'pbrisbin/vim-colors-off'
	use 'owickstrom/vim-colors-paramount'
	use 'navarasu/onedark.nvim'
	use 'morhetz/gruvbox'
	use 'sonph/onehalf'
	use 'liuchengxu/space-vim-dark'
	use 'kabbamine/yowish.vim'
	use 'arcticicestudio/nord-vim'
	use { "mcchrish/zenbones.nvim", requires = "rktjmp/lush.nvim" }

	-- Git
	use 'airblade/vim-gitgutter'
	use 'tpope/vim-fugitive'

	-- Terminal
	use 'akinsho/toggleterm.nvim'
end)
