local function req(x)
	local success, ret = pcall(require, x)
	if not success then
		print(ret)
	end
end

req 'plugins'

req 'abbrevs'
req 'settings'
req 'autocmds'
req 'keybindings'
req 'colorscheme'

req 'treesitter'
req 'nerdtree'
req 'header'
req 'linter'
req 'lsp'
