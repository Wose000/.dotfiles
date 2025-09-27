local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local Notification = require("modules.notification-widget.notification")

local M = {}

-- Setup icon
local bar_icon = wibox.widget.textbox()
bar_icon.font = "JetBrainMono Nerd Font Mono 12"
bar_icon.halign = "center"
bar_icon.valign = "center"
bar_icon.forced_width = 17
bar_icon.markup = "<span color='" .. beautiful.inactive .. "'>󰍥</span>"

M.notifications = {}

M.window = wibox()

local notification_list = require("modules.core.scrollable_container").scrollable_layout()

local bg = wibox.container.background()
bg.bg = beautiful.bg_normal

local title = wibox.widget({
	{ widget = wibox.widget.textbox, markup = "<b>" .. "Notification Center" .. "</b>" },
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
})

M.window:setup({
	{ widget = title },
	{ widget = notification_list },
	widget = wibox.container.margin,
	top = 0,
	left = 10,
	right = 10,
	layout = wibox.layout.fixed.vertical,
})
local _, h = root.size()
M.window.screen = screen[1]
M.window.ontop = true
M.window.width = 300
M.window.height = h

function M:display_widget()
	M.window.visible = not M.window.visible
end

bar_icon:buttons(awful.button({}, 1, function()
	M.window.visible = not M.window.visible
end))

naughty.connect_signal("request::display", function(notification)
	local n = Notification.new(notification)
	local w = n:get_widget()
	table.insert(M.notifications, n)
	notification_list:add(w)
	bar_icon.markup = "<span color='" .. beautiful.accent .. "'>󰍥</span>"
	n:set_dismiss_callback(function()
		table.remove(M.notifications, n:get_index(M.notifications))
		notification_list:remove_widgets(w)
		if #M.notifications == 0 then
			bar_icon.markup = "<span color='" .. beautiful.bg_hover .. "'>󰍥</span>"
		end
	end)
end)

function M:get_bar_icon()
	return bar_icon
end

return M
