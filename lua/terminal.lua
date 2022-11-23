require('keybindings')

require('toggleterm').setup{
	size=15,
	direction='horizontal',

	open_mapping=[[<leader>o]],
	terminal_mappings=false,
	insert_mappings=false,
	start_in_insert=false,
	shade_terminals=false,
	winbar = {
		enabled = true,
	}
}

local t = require('toggleterm.terminal')

local function find_current_term(terms)
	local window = vim.api.nvim_get_current_win()
	for i, term in pairs(terms) do
		if term.window == window then
			return i, term
		end
	end
	return nil
end

return {
	next_term = function()
		local terms = t.get_all()
		local i, current = find_current_term(terms)
		if current ~= nil then
			local n = (((i - 1) + 1) % #terms) + 1
			print("next:", n)
			terms[n]:toggle()
			current:toggle()
		end
	end,
	prev_term = function()
		local terms = t.get_all()
		local i, current = find_current_term(terms)
		if current ~= nil then
			local n = (((i - 1) - 1) % #terms) + 1
			print("prev:", n)
			terms[n]:toggle()
			current:toggle()
		end
	end,
	quit_if_no_terminals = function()
		local terms = t.get_all()
		local n = #terms
		vim.fn.system('echo "'..n..'" >> ran')
		if n ~= 0 then
			local message = "There are "..n.." open terminals, please close them before quitting"
			if n == 1 then
				message = "There's an open terminal, please close it before quitting"
			end

			for _, term in pairs(terms) do
				term:close()
			end

			terms[1]:open()
			print(message .. "\n\n")
		else
			vim.cmd "qa"
		end
	end,
}
