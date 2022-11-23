local packages = {
	'plugins',
	
	'abbrevs',
	'settings',
	'autocmds',
	'keybindings',
	'colorscheme',
	
	'treesitter',
	'tele',
	'nerdtree',
	'terminal',
	'lsp',
}

local function req(x)
	local success, ret = pcall(require, x)
	if not success then
		print(ret)
	end
end

-- Unload packages
for _, x in pairs(packages) do
	package.loaded[x] = nil
end

-- Reload them
for _, x in pairs(packages) do
	req(x)
end

