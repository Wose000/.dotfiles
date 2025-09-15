local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local rclone = require("modules.utils.rclone")
local helpers = require("modules.utils.helpers")

local Task = {}

Task.__index = Task

function Task.new(data)
	local self = setmetatable({}, Task)
	self.data = data
	return self
end

function Task:get_widget()
	local label = wibox.widget.textbox()
	label.font = beautiful.widget_font .. " 11"
	label.valign = "center"
	label.halign = "left"
	label.markup = helpers.colorize_text(self.data.title, beautiful.fg_normal)

	local check_icon = wibox.widget.textbox()
	check_icon.markup = "󰄱"
	check_icon.valign = "center"
	check_icon.halign = "right"
	check_icon.font = beautiful.icon .. " 10"

	local checked_icon = "󰱒"

	local layout = wibox.layout.flex.horizontal()
	layout:add(label)
	layout:add(check_icon)
	return wibox.widget({
		{ widget = layout },
		widget = wibox.container.margin,
		right = 15,
		left = 15,
	})
end

return Task
