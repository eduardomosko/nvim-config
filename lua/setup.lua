
function run(fn)
	local success = pcall(fn)
	if not success then
		vim.notify('err: ' .. success)
	end
end

-- Setup surround
run(function()
	require("nvim-surround").setup()
end)

