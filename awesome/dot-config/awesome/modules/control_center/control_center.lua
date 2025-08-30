local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local M = {}

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

M.control_center:setup({
	{ widget = title },
	{ widget = volume_control.widget },
	{ widget = brightness_control.widget },
	layout = wibox.layout.fixed.vertical,
})
local _, h = root.size()
M.control_center.screen = screen[1]
M.control_center.ontop = true
M.control_center.width = 300
M.control_center.height = h

local bar_icon = wibox.widget.textbox()
bar_icon.font = "JetBrainMono Nerd Font Mono 12"
bar_icon.halign = "center"
bar_icon.valign = "center"
bar_icon.forced_width = 17
bar_icon.markup = "<span color='" .. beautiful.inactive .. "'></span>"

function M:display_widget()
	M.control_center.visible = not M.control_center.visible
end

bar_icon:buttons(awful.button({}, 1, function()
	M.control_center.visible = not M.control_center.visible
end))

function M:get_bar_icon()
	return bar_icon
end

return M
