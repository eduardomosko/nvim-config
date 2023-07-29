local M = {}

M.cabbrev = function(tbl)
	vim.cmd({cmd = 'cnoreabbrev', args = tbl})
end

function section(name, fn)
	local success, err = pcall(fn, function(subname, fn)
		section(name..'/'..subname, fn)
	end)
	if not success then
		vim.notify('failed section "'..name..'":\n' .. err, vim.log.levels.ERROR)
	end
end

M.section = section

return M
