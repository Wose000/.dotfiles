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

function Task:get_icon()
	if self.data.is_completed then
		return "󰱒"
	else
		return "󰄱"
	end
end
function Task:get_title()
	if self.data.is_completed then
		return "<s>" .. self.data.title .. "</s>"
	else
		return self.data.title
	end
end

function Task:get_widget()
	self.label = wibox.widget.textbox()
	self.label.font = beautiful.widget_font .. " 11"
	self.label.valign = "center"
	self.label.halign = "left"
	self.label.markup = helpers.colorize_text(self:get_title(), beautiful.fg_normal)
	self.check_icon = wibox.widget.textbox()
	self.check_icon.markup = self:get_icon()
	self.check_icon.valign = "center"
	self.check_icon.halign = "right"
	self.check_icon.font = beautiful.icon .. " 10"

	local layout = wibox.layout.flex.horizontal()
	layout:add(self.label)
	layout:add(self.check_icon)
	return wibox.widget({
		{ widget = layout },
		widget = wibox.container.margin,
		right = 15,
		left = 15,
	})
end

function Task:toggle()
	if self.data.is_completed then
		self.data.is_completed = false
		self.label.markup = helpers.colorize_text(self:get_title(), beautiful.fg_normal)
		self.check_icon.markup = self:get_icon()
	else
		self.data.is_completed = true
		self.label.markup = helpers.colorize_text(self:get_title(), beautiful.fg_normal)
		self.check_icon.markup = self:get_icon()
	end
end

return Task
