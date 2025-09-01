local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local max_brightness_file = "/sys/class/backlight/intel_backlight/max_brightness"
local brightness_file = "/sys/class/backlight/intel_backlight/brightness"
local brightness_script = "/home/wose/bin/brightness"

local brightness_control = {}

local function calc_percentage_of_brightness(p)
	local decimal_percentage = p / 100
	local brightness_val = math.floor((brightness_control.max_brightness * decimal_percentage) + 0.5)
	if brightness_val >= brightness_control.max_brightness then
		return brightness_control.max_brightness
	end
	if brightness_val <= 0 then
		return 1
	end
	return brightness_val
end

-- Set max brightness reading it from the max_brightness system file
awful.spawn.easy_async_with_shell("cat " .. max_brightness_file, function(stout, sterr, _, exit_code)
	if exit_code == 0 then
		local max_brightness = tonumber(stout)
		if max_brightness then
			brightness_control.max_brightness = max_brightness
		else
			naughty.notification({
				title = "error",
				message = "error converting to a number to output of: cat " .. max_brightness_file,
			})
			error("Error converting the output of cat to a number")
		end
	else
		naughty.notification({
			title = "error",
			message = "Error reading the file " .. max_brightness_file .. " " .. sterr,
		})
		error("Error executing the script exit code: " .. exit_code .. "\nError: " .. sterr)
	end
end)

awful.spawn.easy_async_with_shell("cat " .. brightness_file, function(stout, sterr, _, exit_code)
	if exit_code == 0 then
		local brightness = tonumber(stout)
		if brightness then
			brightness_control.brightness = brightness
		else
			naughty.notification({
				title = "error",
				message = "error converting to a number to output of: cat " .. brightness_file,
			})
		end
	else
		naughty.notification({
			title = "error",
			message = "Error reading the file " .. brightness_file .. " " .. sterr,
		})
	end
end)

local slider = wibox.widget({
	bar_shape = gears.shape.rounded_rect,
	bar_height = 10,
	bar_color = beautiful.inactive,
	bar_active_color = beautiful.accent,
	handle_color = beautiful.accent,
	handle_shape = gears.shape.circle,
	handle_width = 10,
	handle_border_color = beautiful.border_normal,
	handle_border_width = 1,
	value = 100,
	maximum = 100,
	minimum = 0,
	widget = wibox.widget.slider,
})

local label = wibox.widget.textbox("Brightness")

brightness_control.widget = wibox.widget({
	{ { widget = label }, { widget = slider }, layout = wibox.layout.fixed.vertical },
	widget = wibox.container.background,
	bg = beautiful.inactive,
	forced_height = 30,
})

--- max_brightness : 100 = brightness : x

-- Connect to `property::value` to use the value on change
slider:connect_signal("property::value", function(_, new_value)
	local new_brightness = calc_percentage_of_brightness(new_value)
	awful.spawn.easy_async_with_shell("sudo " .. brightness_script .. " " .. new_brightness, function() end)
end)

local function percentage_out_of_value(val)
	local tmp = val * 100 / brightness_control.max_brightness
	return math.floor(tmp + 0.5)
end

return brightness_control
