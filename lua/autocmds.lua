local function autocmd(command)
	vim.cmd("autocmd " .. command)
end

-- Recompile plugins.lua
autocmd "BufWritePost plugins.lua PackerCompile"

-- AutoReload config on edit
autocmd 'BufWritePost ~/.config/nvim/**/*.lua luafile %'

-- GoFmt
autocmd "BufWritePost *.go silent !gofmt -w %"
autocmd "BufWritePost *.go e"

