local M = {}

local c = require("colors.base")
local get_hl_groups = require("groups.base").get

print(type(c))

function M.apply_hi(groups)
	for group, style in pairs(groups) do
		vim.api.nvim_set_hl(0, group, style)
	end
end

function M.test()
	M.apply_hi(get_hl_groups(c))
end
