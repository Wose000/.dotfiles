local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local widget = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_height = 3,
	bar_color = beautiful.border_normal,
	handle_color = beautiful.bg_normal,
	handle_shape = gears.shape.circle,
	handle_border_color = beautiful.border_normal,
	handle_border_width = 1,
	value = 25,
	widget = wibox.widget.slider,
})

-- Connect to `property::value` to use the value on change
widget:connect_signal("property::value", function(_, new_value)
	naughty.notify({ title = "Slider changed", message = tostring(new_value) })
end)
