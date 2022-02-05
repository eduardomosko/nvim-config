local map = vim.api.nvim_set_keymap

local function nmap(mapping)
	local pos = mapping:find(' ')
	local kb = mapping:sub(0, pos - 1)
	local cmd = mapping:sub(pos + 1)
	map('n', kb, cmd, {silent = true, noremap = true})
end

vim.g.mapleader = ' '

local nrm = { silent = true, noremap = true }

nmap '<leader>t <cmd>NERDTreeToggle<cr>'

-- Navigation
map('n', '<leader>h', '<C-w>h', nrm)
map('n', '<leader>j', '<C-w>j', nrm)
map('n', '<leader>k', '<C-w>k', nrm)
map('n', '<leader>l', '<C-w>l', nrm)

map('n', 'çh', ':bp<cr>', nrm)
map('n', 'çl', ':bn<cr>', nrm)
map('n', 'çk', ':tabn<cr>', nrm)
map('n', 'çj', ':tabp<cr>', nrm)

-- Terminal life
nmap '<leader>ot :bot 15sp | term<enter>A'
map('t', '<esc>', '<C-\\><C-n>', nrm)

-- GitGutter
--  Disable old
nmap '<leader>_a <Plug>(GitGutterStageHunk)'
nmap '<leader>_b <Plug>(GitGutterUndoHunk)'
nmap '<leader>_c <Plug>(GitGutterPreviewHunk)'

--  Enable new
nmap '<leader>gs <cmd>GitGutterStageHunk<cr>'
nmap '<leader>gu <cmd>GitGutterUndoHunk<cr>'
nmap '<leader>gp <cmd>GitGutterPreviewHunk<cr>'
nmap '<leader>gn <cmd>GitGutterNextHunk<cr>'
nmap '<leader>gN <cmd>GitGutterPrevHunk<cr>'

-- Telescope
nmap "<leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>"
nmap "<leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>"

-- Closing files
nmap 'ZA <cmd>qa<cr>'

-- Lsp
function lsp(client, bufnr)
	local bmap = function(kb, cmd)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', kb, cmd, nrm)
	end

	bmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
	bmap('<leader>gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
	bmap(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
	bmap('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')
	bmap('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
end

return {
	lsp = lsp,
}
