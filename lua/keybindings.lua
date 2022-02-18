local map = vim.api.nvim_set_keymap

local opts = {silent = true, noremap = true}
local nmap = function(kb, cmd) map('n', kb, cmd, opts) end
local tmap = function(kb, cmd) map('t', kb, cmd, opts) end

vim.g.mapleader = ' '

nmap('<leader>t', '<cmd>NERDTreeToggle<cr>')

-- Navigation
nmap('<leader>h', '<C-w>h')
nmap('<leader>j', '<C-w>j')
nmap('<leader>k', '<C-w>k')
nmap('<leader>l', '<C-w>l')

nmap('çh', ':bp<cr>')
nmap('çl', ':bn<cr>')
nmap('çk', ':tabn<cr>')
nmap('çj', ':tabp<cr>')

-- Terminal life
tmap('<esc>', '<C-\\><C-n>')

-- GitGutter
--  Disable old
nmap('<leader>_a', '<Plug>(GitGutterStageHunk)')
nmap('<leader>_b', '<Plug>(GitGutterUndoHunk)')
nmap('<leader>_c', '<Plug>(GitGutterPreviewHunk)')

--  Enable new
nmap('<leader>gs', '<cmd>GitGutterStageHunk<cr>')
nmap('<leader>gu', '<cmd>GitGutterUndoHunk<cr>')
nmap('<leader>gp', '<cmd>GitGutterPreviewHunk<cr>')
nmap('<leader>gn', '<cmd>GitGutterNextHunk<cr>')
nmap('<leader>gN', '<cmd>GitGutterPrevHunk<cr>')

-- Telescope
nmap("<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>")
nmap("<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")

-- Closing files
nmap('ZA', '<cmd>qa<cr>')

-- Formatting
nmap('<C-I>', "<cmd>lua require('formatter').format()<cr>")

-- Lsp
return {
	lsp = function(client, bufnr)
		local bmap = function(kb, cmd)
			vim.api.nvim_buf_set_keymap(bufnr, 'n', kb, cmd, opts)
		end

		bmap('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
		bmap('<leader>d', '<cmd>lua vim.lsp.buf.definition()<cr>')
		bmap(']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
		bmap('[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
		bmap('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
	end,
}
