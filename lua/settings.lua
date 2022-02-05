local o = {
	showmode = false,
	hidden = true,
	hlsearch = false,
	tabstop = 4,
	shiftwidth = 4,
	wrap = false,
	cinoptions='(1s',
	termguicolors = true,
	signcolumn='yes',
}

local bo = {
	tabstop = 4,
	shiftwidth = 4,
	cinoptions='(1s',
}

local wo = {
	number = true,
	cursorline = true,
	wrap = false,
}

for k, v in pairs(o) do vim.o[k] = v end
for k, v in pairs(bo) do vim.bo[k] = v end
for k, v in pairs(wo) do vim.wo[k] = v end
