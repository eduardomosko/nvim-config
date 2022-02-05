local lsp = require 'lspconfig'
local kbs = require './keybindings'

local install_path = vim.fn.stdpath('data') .. '/lsp'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.api.nvim_command('!mkdir ' .. install_path)
end

local configs = {
	rust_analyzer = {
		cmd = "rust-analyzer",
		download = "wget -qO- https://github.com/rust-analyzer/rust-analyzer/releases/download/2022-01-31/rust-analyzer-x86_64-unknown-linux-gnu.gz | gzip -d >",
	}
}

for n, data in pairs(configs) do
	-- Auto install lsps
	local target = install_path .. '/' .. data.cmd
	if vim.fn.empty(vim.fn.glob(target)) > 0 then
		vim.api.nvim_command('!bash -c "' .. data.download .. ' ' .. target .. '"')
		vim.api.nvim_command('!chmod +x ' .. target)
	end

	lsp[n].setup{
		cmd = { target },
		flags = {
			debounce_text_changes = 150,
		},
		on_attach = kbs.lsp,
	}
end
