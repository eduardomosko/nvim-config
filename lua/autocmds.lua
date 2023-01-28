local function autocmd(command)
	vim.cmd("autocmd " .. command)
end

-- Recompile plugins.lua
autocmd "BufWritePost plugins.lua luafile %"
autocmd "BufWritePost plugins.lua PackerCompile"

-- AutoSave files
require('auto-save').setup{
	debounce_delay = 5000,
	execution_message = {
		message = function() return ("") end,
	}
}
