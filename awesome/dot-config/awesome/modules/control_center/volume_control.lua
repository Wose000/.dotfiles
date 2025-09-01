local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

local pactl = require("awesome-wm-widgets.pactl-widget.pactl")

local volume_control = {}
local max_volume_value = 65536
local default_sink = "@DEFAULT_SINK@"

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

local label = wibox.widget.textbox("Volume")

volume_control.widget = wibox.widget({
	{ { widget = label }, {
		widget = slider,
	}, layout = wibox.layout.fixed.vertical },
	widget = wibox.container.background,
	forced_height = 40,
	bg = beautiful.inactive,
})

slider:connect_signal("property::value", function(_, new_value)
	local new_volume = percentage_of_max_volume(new_value)
	volume_control.set_volume(new_volume)
end)

return volume_control
