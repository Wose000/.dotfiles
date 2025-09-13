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
	label.halign = "center"
	label.markup = helpers.colorize_text(self.data.name, beautiful.fg_normal)
end

return Task
