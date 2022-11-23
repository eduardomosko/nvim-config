local CURRENT_BUF = 0

local formatters = {
	rust = 'rustfmt --edition "2021"',
	go = 'go run golang.org/x/tools/cmd/goimports@latest',
	html = 'npx prettier --parser html',
	svelte = 'npx prettier --parser svelte',
	javascript = 'npx prettier --parser flow',
	typescript = 'npx prettier --parser typescript',
	json = 'npx prettier --parser json',
	css = 'npx prettier --parser css',
}

-- Compares every item of a table
local function equals(l1, l2) 
	if #l1 ~= #l2 then
		return false
	end

	for i = 0, #l1 do
		if l1[i] ~= l2[i] then
			return false
		end
	end

	return true
end

return {
	format = function()
		local ft = vim.bo.filetype
		local format = formatters[ft]
	
		if format ~= nil then
			print('format')
			local oldlines = vim.api.nvim_buf_get_lines(CURRENT_BUF, 0, -1, true)
	
			local newlines = vim.fn.systemlist(format, oldlines, true)
			if vim.v.shell_error ~= 0 then
				print(table.concat(newlines, '\n'))
				return
			end
	
			if not equals(newlines, oldlines) then
				vim.api.nvim_buf_set_lines(CURRENT_BUF, 0, -1, true, newlines)
			end
		else
			print('no formatter available')
		end
	end,
}
