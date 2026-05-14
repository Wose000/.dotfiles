local M = {}

local get_colors = require("colors.base")
local get_hl_groups = require("groups.base").get

function M.apply_hi(groups)
	vim.cmd("hi clear")
	for group, style in pairs(groups) do
		if type(style) ~= "string" then
			vim.api.nvim_set_hl(0, group, style)
		end
	end
end

function M.test()
	print("does this even try to work")
	M.apply_hi(get_hl_groups(get_colors.get(), {}))
end

M.test()
