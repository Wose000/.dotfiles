local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local M = {}

local window = awful.popup({
	screen = screen[1],
	widget = {
		{
			{
				text = "foobar",
				widget = wibox.widget.textbox,
			},
			{
				{
					text = "foobar",
					widget = wibox.widget.textbox,
				},
				bg = "#ff00ff",
				clip = true,
				shape = gears.shape.rounded_bar,
				widget = wibox.widget.background,
			},
			{
				value = 0.5,
				forced_height = 30,
				forced_width = 100,
				widget = wibox.widget.progressbar,
			},
			layout = wibox.layout.fixed.vertical,
		},
		margins = 10,
		widget = wibox.container.margin,
	},
	border_color = "#00ff00",
	border_width = 5,
	ontop = true,
	placement = awful.placement.top_left,
	shape = gears.shape.rounded_rect,
	visible = true,
})

local bar_icon = wibox.widget({
	widget = wibox.widget.textbox,
	text = "0",
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
