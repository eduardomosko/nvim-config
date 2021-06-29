local lint = require('lint')
local norme = require('norme')

lint.linters.norme = norme.linter

lint.linters_by_ft = {
	c    = { 'norme' },
	cpp  = { 'norme' },
}
