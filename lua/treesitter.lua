-- Uses patched version of parser
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.svelte = {
	install_info = {
		url = "https://github.com/eduardomosko/tree-sitter-svelte",
		branch = "fix-empty-await-then",
		files = { "src/parser.c", "src/scanner.c" },
		revision = '35e4e149475a3386d6cf614e35436a47d26a876d',
	},
}

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
		'html',
	},
	highlight = { enable = true }
}
