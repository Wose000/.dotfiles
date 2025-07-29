local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local M = {}

local notification_list =
	naughty.list.notifications({ base_layout = wibox.widget({
		layout = wibox.layout.flex.vertical,
	}) })

local window = awful.popup({
	widget = {
		{ widget = notification_list },
		widget = wibox.widget.background,
		color = beautiful.bg_normal,
		forced_width = 200,
	},
	screen = screen[1],
	placement = awful.placement.top_left,
	ontop = true,
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
	naughty.notification({ title = "ciao", message = "cazzo", timeout = 10000 })
end))

function M:get_bar_icon()
	return bar_icon
end

return M
