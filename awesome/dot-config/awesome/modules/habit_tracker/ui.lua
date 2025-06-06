local wibox = require("wibox.init")
local awful = require("awful")
local gears = require("gears")

local bar_icon = wibox.widget({
	widget = wibox.widget.textbox,
	text = "H",
	align = "center",
	valign = "center",
})

local popup = awful.popup({
	widget = {
		{
			text = "Habits",
			widget = wibox.widget.textbox,
		},
		margins = 10,
		widget = wibox.container.margin,
	},
	border_color = "#000000",
	border_width = 2,
	placement = awful.placement.centered,
	ontop = true,
	visible = false,
	shape = gears.shape.rounded_rect,
})

bar_icon:buttons(awful.button({}, 1, function()
	popup.visible = not popup.visible
end))

return bar_icon
