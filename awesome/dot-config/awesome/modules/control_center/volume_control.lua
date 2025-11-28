local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local pactl = require("awesome-wm-widgets.pactl-widget.pactl")

local volume_control = {}
local max_volume_value = 65536
local default_sink = "@DEFAULT_SINK@"

local function percentage_of_val(val, max)
	local tmp = val * 100 / max
	return math.floor(tmp + 0.5)
end

local function percentage_of_max_volume(p)
	local decimal_percentage = p / 100
	local volume_val = math.floor((max_volume_value * decimal_percentage) + 0.5)
	if volume_val >= max_volume_value then
		return max_volume_value
	end
	if volume_val <= 0 then
		return 1
	end
	return volume_val
end

function volume_control.set_volume(vol)
	awful.spawn("pactl set-sink-volume " .. default_sink .. " " .. vol, false)
end

function volume_control.get_widget(vol)
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
		value = vol,
		maximum = 100,
		minimum = 0,
		widget = wibox.widget.slider,
	})

	local slider_icon = wibox.widget({
		{ widget = wibox.widget.textbox, markup = " ", font = beautiful.icon .. " 13", valign = "center" },
		{ widget = slider },
		layout = wibox.layout.fixed.horizontal,
	})

	local label = wibox.widget.textbox("Volume")

	slider:connect_signal("property::value", function(_, new_value)
		local new_volume = percentage_of_max_volume(new_value)
		volume_control.set_volume(new_volume)
	end)

	return wibox.widget({
		{ { widget = label }, {
			widget = slider_icon,
		}, layout = wibox.layout.fixed.vertical },
		widget = wibox.container.background,
		forced_height = 40,
		bg = beautiful.inactive,
	})
end

volume_control.volume = 1
volume_control.widget = volume_control.get_widget(volume_control.volume)

function volume_control.init()
	local get_volume_command = 'pactl get-sink-volume @DEFAULT_SINK@ | grep "Volume"'
	awful.spawn.easy_async_with_shell(get_volume_command, function(stdout, sterr, _, exit_code)
		if exit_code == 0 then
			local volume = tonumber(string.match(stdout, "%d+"))
			volume_control.volume = percentage_of_val(volume, max_volume_value)
			volume_control.widget:emit_signal_recursive("update::volume")
		end
	end)
end

return volume_control
