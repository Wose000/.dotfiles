local wibox = require("wibox")
local awful = require("awful")

local M = {}

function M.scrollable_layout()
	local layout = wibox.layout.fixed.vertical()

	layout:add_button(awful.button({}, 5, function()
		local first = layout.children[1]
		for i = 2, #layout.children, 1 do
			layout:set(i - 1, layout.children[i])
		end
		layout:set(#layout.children, first)
	end))

	layout:add_button(awful.button({}, 4, function()
		local last = layout.children[#layout.children]
		for i = #layout.children - 1, 1, -1 do
			layout:set(i + 1, layout.children[i])
		end
		layout:set(1, last)
	end))

	return layout
end

return M
