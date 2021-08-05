local norme = require('norme')
local null_ls = require('null-ls')
local lspconfig = require('lspconfig')

null_ls.config()
lspconfig['null-ls'].setup({})
norme.setup()
