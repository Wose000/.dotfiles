local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local max_brightness_file = "/sys/class/backlight/intel_backlight/max_brightness"
local max_brightness_value = -1

awful.spawn.easy_async_with_shell("cat" .. max_brightness_file, function(stout, sterr, _, exit_code)
	if exit_code == 0 then
		local max_brightness = tonumber(stout)
		if max_brightness then
			max_brightness_value = max_brightness
		else
			naughty.notification({
				title = "error",
				message = "error converting to a number to output of: cat " .. max_brightness_file,
			})
		end
	else
		naughty.notification({
			title = "error",
			message = "Error reading the file " .. max_brightness_file .. " " .. sterr,
		})
	end
end)

local widget = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_height = 3,
	bar_color = beautiful.border_normal,
	handle_color = beautiful.bg_normal,
	handle_shape = gears.shape.circle,
	handle_border_color = beautiful.border_normal,
	handle_border_width = 1,
	value = max_brightness_value,
	widget = wibox.widget.slider,
})

-- Connect to `property::value` to use the value on change
widget:connect_signal("property::value", function(_, new_value)
	naughty.notify({ title = "Slider changed", message = tostring(new_value) })
end)
