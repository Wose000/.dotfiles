local M = {}

local c = require("colors.base").colors
local get_hl_groups = require("groups.base").get

function M.apply_hi(groups)
	if vim.g.colors_name then
		vim.cmd("hi clear")
	end
	for group, style in pairs(groups) do
		if type(style) ~= "string" then
			vim.api.nvim_set_hl(0, group, style)
		end
	end
end

function M.test()
	M.apply_hi(get_hl_groups(c, {}))
	print("does this even try to work")
end

M.test()
