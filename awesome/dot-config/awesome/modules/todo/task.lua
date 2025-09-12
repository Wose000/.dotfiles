local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")

-- Task.__index = Task
--
-- function Task.new(data)
-- 	local self = setmetatable({}, Task)
-- 	self.data = data
-- 	return self
-- end

local M = {}
local rclone = require("modules.utils.rclone")

M.box = wibox()
local layout = wibox.layout.fixed.vertical()
M.box:setup({
	layout = layout,
})
M.widget = wibox.widget({
	widget = wibox.container.background,
	bg = beautiful.inactive,
	forced_height = 100,
	forced_width = 250,
})

layout:add(M.widget)
layout:connect_signal("fuck", function()
	naughty.notification({ title = "cazzo", message = "what is goin one" })
end)

local function signal()
	M.widget:emit_signal_recursive("fuck")
end

rclone.cat_with_signal(".data/tasks.json", "onedrive", signal)

local _, h = root.size()
M.box.screen = screen[1]
M.box.ontop = true
M.box.width = 300
M.box.height = h

local bar_icon = wibox.widget.textbox()
bar_icon.font = "JetBrainMono Nerd Font Mono 12"
bar_icon.halign = "center"
bar_icon.valign = "center"
bar_icon.forced_width = 17
bar_icon.markup = "<span color='" .. beautiful.accent .. "'></span>"

bar_icon:buttons(awful.button({}, 1, function()
	M.box.visible = not M.box.visible
end))

function M.get_bar_icon()
	return bar_icon
end

return M
