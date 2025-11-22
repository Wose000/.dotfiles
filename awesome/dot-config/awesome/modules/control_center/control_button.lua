local helpers = require("modules.utils.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local button = wibox.widget({
	{
		{
			{ markup = "0", widget = wibox.widget.textbox, valign = "center", halign = "center" },
			margin = 100,
			widget = wibox.container.margin,
		},
		shape = gears.shape.squircle,
		bg = beautiful.inactive,
		widget = wibox.container.background,
	},
	strategy = "min",
	width = 200,
	height = 200,
	widget = wibox.container.constraint,
})

return button
