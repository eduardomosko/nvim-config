require('nvim-treesitter.configs').setup {
	ensure_installed = {
		'c',
		'javascript',
		'typescript',
		'svelte',
		'bash',
		'python',
		'yaml',
		'json',
		'go',
		'cpp',
		'css',
	},
	highlight = { enable = true }
}
