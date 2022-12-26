local function autocmd(command)
	vim.cmd("autocmd " .. command)
end

-- Recompile plugins.lua
autocmd "BufWritePost plugins.lua PackerCompile"
autocmd "BufWritePost plugins.lua <cmd>luafile %<cr>"

-- AutoSave files
require('auto-save').setup{
	debounce_delay = 5000,
	execution_message = {
		message = function() return ("") end,
	}
}
