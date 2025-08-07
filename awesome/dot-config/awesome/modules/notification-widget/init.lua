local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local M = {}

M.notifications = {}

local layout = wibox.layout.fixed.vertical()

naughty.connect_signal("request::display", function(notification, context, args)
	table.insert(M.notifications, notification)
	local n = wibox.widget({
		widget = wibox.widget.textbox(notification.title),
	})
	layout:add(n)
end)

M.window = wibox()

local bg = wibox.container.background()
bg.bg = beautiful.bg_normal

M.window:setup({
	{ widget = layout },
	widget = bg,
})
M.window.ontop = true
M.window.width = 300
M.window.height = 1000
local bar_icon = wibox.widget({
	widget = wibox.widget.textbox,
	text = "󰍥",
	font = "Jet Brains Mono Nerd Font Mono 17",
	align = "center",
	valign = "center",
})

function M:display_widget()
	M.window.visible = not M.window.visible
end

bar_icon:buttons(awful.button({}, 1, function()
	M.window.visible = not M.window.visible
	naughty.notification({ title = "ciao", message = "cazzo", timeout = 10000 })
end))

function M:get_bar_icon()
	return bar_icon
end

return M
