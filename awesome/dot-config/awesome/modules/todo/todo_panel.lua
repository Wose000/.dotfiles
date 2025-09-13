local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local M = {}

M.box = wibox()
M.box.screen = screen[1]
M.box.ontop = true
M.box.width = 300
M.box.height = select(2, root.size())
local task_list = wibox.layout.fixed.vertical()

M.box:setup({
	layout = task_list,
})

function M.get_bar_icon()
	local bar_icon = wibox.widget.textbox()
	bar_icon.font = "JetBrainMono Nerd Font Mono 12"
	bar_icon.halign = "center"
	bar_icon.valign = "center"
	bar_icon.forced_width = 17
	bar_icon.markup = "<span color='" .. beautiful.accent .. "'></span>"

	bar_icon:buttons(awful.button({}, 1, function()
		M.box.visible = not M.box.visible
	end))
	return bar_icon
end

return M
