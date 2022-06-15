local toggleterm = require 'toggleterm'

toggleterm.setup{
	size=15,
	direction='horizontal',

	open_mapping=[[<leader>o]],
	terminal_mappings=false,
	insert_mappings=false,
	start_in_insert=false,
	shade_terminals=false,
}
