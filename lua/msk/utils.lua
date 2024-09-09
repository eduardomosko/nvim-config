local M = {}

function M.cabbrev(tbl)
	vim.cmd({ cmd = 'cnoreabbrev', args = tbl })
end

function M.section(name, fn)
	local success, err = pcall(fn, function(subname, fn)
		M.section(name .. '/' .. subname, fn)
	end)
	if not success then
		vim.notify('failed section "' .. name .. '":\n' .. err, vim.log.levels.ERROR)
	end
end

function M.bootstrap_lazy()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out,                            "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end
	vim.opt.rtp:prepend(lazypath)
end

return M
