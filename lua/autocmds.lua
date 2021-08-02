local function autocmd(command)
	vim.cmd("autocmd " .. command)
end

-- Recompile plugins.lua
autocmd "BufWritePost plugins.lua PackerCompile"

-- Norme
autocmd "BufEnter     *.c,*.h lua require('norme').lint()"
autocmd "InsertLeave  *.c,*.h lua require('norme').lint()"
autocmd "TextChanged  *.c,*.h lua require('norme').lint()"
autocmd "BufWritePost *.c,*.h lua require('norme').lint()"

-- AutoReload config on edit
autocmd 'BufWritePost ~/.config/nvim/**/*.lua luafile %'

-- GoFmt
autocmd "BufWritePost *.go silent !gofmt -w %"
autocmd "BufWritePost *.go e"

