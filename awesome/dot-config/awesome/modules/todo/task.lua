local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local rclone = require("modules.utils.rclone")

local Task = {}

Task.__index = Task

function Task.new(data)
	local self = setmetatable({}, Task)
	self.data = data
	return self
end

return Task
