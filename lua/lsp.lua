local lsp = require 'lspconfig'
local kbs = require './keybindings'

local function path_exists(path)
	return vim.fn.filereadable(vim.fn.glob(install_path))
end

local install_path = vim.fn.stdpath('data') .. '/lsp'
if not path_exists(install_path) then
	vim.api.nvim_command('!mkdir ' .. install_path)
end

-- Each config is a function that auto-installs the lsp
-- and returns a command to run it
local configs = {
	rust_analyzer = function()
		local cmd = "rust-analyzer"
		local download = "wget -qO- https://github.com/rust-analyzer/rust-analyzer/releases/download/2022-01-31/rust-analyzer-x86_64-unknown-linux-gnu.gz | gzip -d >"
		local target = install_path .. '/' .. cmd

		if not path_exists(target) then
			print('installing rust language server')
			vim.api.nvim_command('!bash -c "' .. data.download .. ' ' .. target .. '"')
			vim.api.nvim_command('!chmod +x ' .. target)
		end

		return { target }
	end,
	gopls = function()
		local tool = 'golang.org/x/tools/gopls@latest' 
		local toolpath = vim.fn.system('go env GOPATH') .. '/bin/gopls'

		if not path_exists(toolpath) then
			print('installing go language server')
			vim.fn.system('go install ' .. tool)
		end

		return { 'go', 'run', tool, 'serve' }
	end,
	svelte = function()
		return { 'svelteserver', '--stdio' }
	end
}

for n, fn in pairs(configs) do
	local success, cmd = pcall(fn)
	if success then
		lsp[n].setup{
			cmd = cmd,
			flags = {
				debounce_text_changes = 150,
			},
			on_attach = kbs.lsp,
		}
	else
		print('failed setting up', n, ':', cmd)
	end
end
