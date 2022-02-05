require('nvim-treesitter.configs').setup {
	ensure_installed = {
		'c',
		'lua',
		'javascript',
		'typescript',
		'bash',
		'python',
		'yaml',
		'json',
		'go',
		'cpp'
	},
	highlight = { enable = true }
}
