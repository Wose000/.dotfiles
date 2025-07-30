local wibox = require("wibox")

local Habit = {}

Habit.__index = Habit

function Habit.new(data)
	local self = setmetatable({}, Habit)
	self.title = data.title
	self.last_check_date = data.last_check_date
	self.successes = data.successes
	self.last_check_value = data.last_check
	self.fails = data.fails
	self.current_streak = data.current_streak
end
