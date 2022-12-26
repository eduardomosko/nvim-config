local lsp = require 'lspconfig'
local kbs = require './keybindings'

local function path_exists(path)
	local res = vim.fn.filereadable(vim.fn.glob(path))
	return res ~= 0
end

local install_path = vim.fn.stdpath('data') .. '/lsp'
if not path_exists(install_path) then
	vim.fn.system('mkdir -p ' .. install_path)
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
			vim.fn.system('bash -c "' .. download .. ' ' .. target .. '"')
			vim.fn.system('chmod +x ' .. target)
		end

		return { cmd = { target } }
	end,
	clangd = function()
		local cmd = "clangd"
		local version = "15.0.3"
		local download = "wget -q https://github.com/clangd/clangd/releases/download/"..version.."/clangd-linux-"..version..".zip && unzip -q clangd-linux-"..version..".zip && rm clangd-linux-"..version..".zip"
		local target = install_path .. '/clangd_15.0.3/bin/' .. cmd

		if not path_exists(target) then
			print('installing clangd language server')
			vim.fn.system("bash -c 'cd "..install_path.." && " .. download .. " && chmod +x "..target.."'")
		end

		return { cmd = { target } }
	end,
	gopls = function()
		local tool = 'golang.org/x/tools/gopls@latest' 
		local gopath = vim.fn.system('go env GOPATH')
		local toolpath = gopath:sub(0, #gopath - 1) .. '/bin/gopls'

		if not path_exists(toolpath) then
			print('installing go language server')
			vim.fn.system('go install ' .. tool)
		end

		return { cmd = { 'go', 'run', tool, 'serve' } }
	end,
	svelte = function()
		local tool = 'svelteserver'

		vim.fn.system({'which', tool})
		local err = vim.v.shell_error

		if vim.v.shell_error ~= 0 then
			print('installing svelte language server')
			vim.fn.system('npm install -g svelte-language-server')
		end

		return {
			cmd = { tool, '--stdio' },
			settings = {
				svelte = {
					plugin = {
						svelte = {
							useNewTransformation = true,
						},
					},
				},
			},
		}
	end,
	tsserver = function()
		local tool = 'typescript-language-server'

		vim.fn.system({'which', tool})
		local err = vim.v.shell_error

		if vim.v.shell_error ~= 0 then
			print('installing typescript language server')
			vim.fn.system('npm install -g typescript ' .. tool)
		end

		return { cmd = { tool, '--stdio' } }
	end,
}

for server, getConfig in pairs(configs) do
	local success, config = pcall(getConfig)
	if success then
		local s, err = pcall(lsp[server].setup, vim.tbl_deep_extend('keep', { flags = { debounce_text_changes = 150, }, on_attach = kbs.lsp, }, config))
		if not s then 
			vim.notify("failed setting up lsp " .. server .. " because: " .. err, vim.log.levels.ERROR)
		end
	else
		vim.notify("failed getting lsp config " .. server .. " because: " .. config, vim.log.levels.ERROR)
	end
end
