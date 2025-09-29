local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local naughty = require("naughty")
local helpers = require("modules.utils.helpers")

local M = {}

local icon = ""

M.control_center = wibox()

local bg = wibox.container.background()
bg.bg = beautiful.bg_normal

local title = wibox.widget({
	{ widget = wibox.widget.textbox, markup = "<b>" .. "Control Center" .. "</b>" },
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
})

local brightness_control = require("modules.control_center.brightness_control")
local volume_control = require("modules.control_center.volume_control")
local layout = wibox.layout.fixed.vertical()

M.control_center:setup({
	layout = layout,
})
layout:add(title)
layout:add(brightness_control.widget)
layout:add(volume_control.widget)

M.control_center.screen = screen[1]
M.control_center.ontop = true
M.control_center.width = 300
M.control_center.height = select(2, root.size())

layout:connect_signal("update::brightness", function()
	local new_brightness = brightness_control.get_widget()
	layout:replace_widget(brightness_control.widget, new_brightness, true)
	brightness_control.widget = new_brightness
end)

layout:connect_signal("update::volume", function()
	local new_volume = volume_control.get_widget(volume_control.volume)
	layout:replace_widget(volume_control.widget, new_volume, true)
	volume_control.widget = new_volume
end)

brightness_control.init()
volume_control.init()

function M:get_bar_icon()
	local bar_icon = wibox.widget.textbox()
	bar_icon.font = beautiful.icon .. " 12"
	bar_icon.halign = "center"
	bar_icon.valign = "center"
	bar_icon.forced_width = 17
	bar_icon.markup = helpers.colorize_text(icon, beautiful.fg_normal)

	bar_icon:connect_signal("mouse::enter", function()
		bar_icon.font = beautiful.icon .. " 13"
		bar_icon.markup = "<b>" .. helpers.colorize_text(icon, beautiful.fg_focus) .. "</b>"
	end)

	bar_icon:connect_signal("mouse::leave", function()
		if M.control_center.visible then
			return
		end
		bar_icon.font = beautiful.icon .. " 12"
		bar_icon.markup = helpers.colorize_text(icon, beautiful.fg_normal)
	end)

	bar_icon:buttons(awful.button({}, 1, function()
		M.control_center.visible = not M.control_center.visible
		if M.control_center.visible then
			bar_icon.font = beautiful.icon .. " 13"
			bar_icon.markup = "<b>" .. helpers.colorize_text(icon, beautiful.fg_focus) .. "</b>"
		else
			bar_icon.font = beautiful.icon .. " 12"
			bar_icon.markup = helpers.colorize_text(icon, beautiful.fg_normal)
		end
	end))
	return bar_icon
end

return M
