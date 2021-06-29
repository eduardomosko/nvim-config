local function cabbrev(abrev)
	vim.cmd("cabbrev " .. abrev)
end

-- Git - fugitive.vim
cabbrev 'git Git'

-- My stupidity
cabbrev 'qw wq'
cabbrev 'Wq wq'
cabbrev 'wQ wq'
cabbrev 'Qw wq'
cabbrev 'qW wq'
