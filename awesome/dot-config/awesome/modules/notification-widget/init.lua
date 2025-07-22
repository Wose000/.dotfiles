local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local M = {}

local window = awful.popup({
	screen = screen[1],
	widget = {
		{ widget = wibox.widget.textbox, text = "Dio cane" },
		widget = wibox.widget.background,
		color = beautiful.bg_normal,
	},
})

local bar_icon = wibox.widget({
	widget = wibox.widget.textbox,
	text = "󰍥",
	font = "Jet Brains Mono Nerd Font Mono 17",
	align = "center",
	valign = "center",
})

function M:display_widget()
	window.visible = not window.visible
end

bar_icon:buttons(awful.button({}, 1, function()
	window.visible = not window.visible
end))

function M:get_bar_icon()
	return bar_icon
end

return M
