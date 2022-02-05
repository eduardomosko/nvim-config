--[[
local lspinstall = require('lspinstall')
local lspconfig  = require('lspconfig')

local configs = {
	clangd = { cmd = {'clangd', '--background-index', '--suggest-missing-includes' } },
	lua    = { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } }
}

local function setup()
	lspinstall.setup()
	local servers = lspinstall.installed_servers()
	for _, server in pairs(servers) do
		lspconfig[server].setup(configs[server] or {})
	end
end
setup()

lspinstall.post_install_hook = function()
	setup()
	vim.cmd "bufdo e"
end

]]--
