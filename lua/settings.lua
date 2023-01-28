local settings = {
	o = {
		showmode = false,
		hidden = true,
		hlsearch = false,
		tabstop = 4,
		shiftwidth = 4,
		wrap = false,
		cinoptions='(1s',
		termguicolors = true,
		signcolumn = 'yes',
		background = 'dark',
	},
	bo = {
		tabstop = 4,
		shiftwidth = 4,
		cinoptions='(1s',
	},
	wo = {
		number = true,
		cursorline = true,
		wrap = false,
	},
}

for locality, opts in pairs(settings) do
	for opt, val in pairs(opts) do
		vim[locality][opt] = val
	end
end
