local function autocmd(command)
	vim.cmd("autocmd " .. command)
end

-- Recompile plugins.lua
autocmd "BufWritePost plugins.lua PackerCompile"
