local wibox = require("wibox")
local date = require("date")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

local Habit = {}

local button_size = 20
local succes_icon = "󰸞"
local fail_icon = ""
local bar_height = 3
local bar_width = 100
local bar_fg_color = beautiful.bg_focus
local bar_bg_color = beautiful.bg_minimize
local widget_background = beautiful.bg_normal
local widget_background_hover = beautiful.bg_hover

---Logging utiliti function
local function log(msg)
	local file = io.open("/home/wose/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/data/log.txt", "a")
	if not file then
		return
	end
	local formatted_datetime = os.date("%Y-%m-%d %H:%M:%S")
	file:write(formatted_datetime .. ": " .. msg .. "\n")
	file:close()
end

Habit.__index = Habit

function Habit.new(data)
	local self = setmetatable({}, Habit)
	self.data = data
	return self
end

---Set the property data for the habit
---@param new_data table
function Habit:set_data(new_data)
	self.data = new_data
end

local function get_checks_needed(last_check_date)
	if last_check_date == "" then
		return 1
	end
	local fmt_date = string.gsub(last_check_date, "-", " ")
	local d = date.diff(date(), date(fmt_date))
	return math.floor(d:spandays())
end

function Habit:checks_needed()
	return get_checks_needed(self.data.last_check_date)
end

function Habit:get_missing_checks_icon()
	if self.data.last_check_date == "" then
		return wibox.widget.textbox("")
	end
	local checks_needed = get_checks_needed(self.data.last_check_date)
	local text = checks_needed > 0 and "x" .. checks_needed .. " 󰀦" or ""
	return wibox.widget.textbox(text)
end

---Get the next day from the last check date
---@return string|osdate
local function get_new_date(last_update_date)
	if last_update_date == "" then
		return os.date("%Y-%m-%d")
	end
	local correct_format_date = string.gsub(last_update_date, "-", " ")
	local curr_date = date(correct_format_date)
	curr_date:adddays(1)
	return curr_date:fmt("%Y-%m-%d")
end

---Increse successes count and current streak, updated best streak if needed
function Habit:success()
	self.data.successes = self.data.successes + 1
	self.data.last_check_date = get_new_date(self.data.last_check_date)
	self.data.current_streak = self.data.current_streak + 1
	if self.data.current_streak > self.data.best_streak then
		self.data.best_streak = self.data.current_streak
	end
	self.data.last_check = "success"
end

---Increase fails count and reset current streak
function Habit:fail()
	self.data.fails = self.data.fails + 1
	self.data.last_check_date = get_new_date(self.data.last_check_date)
	self.data.current_streak = 0
	self.data.last_check = "fail"
end

---Check if the habit has been already checked up until today
---@return boolean
function Habit:is_already_checked()
	return get_checks_needed(self.data.last_check_date) <= 0
end

function Habit:delete_habit()
	self.habit_widget:emit_signal_recursive("habit::delete", self.data.title)
	self.data = nil
end

function Habit:reset_habit()
	self.data.best_streak = 0
	self.data.last_check_date = ""
	self.data.fails = 0
	self.data.successes = 0
	self.data.current_streak = 0
	self.data.last_check = ""
	self.habit_widget:emit_signal_recursive("habit::update", self.data.title)
end

function Habit:get_right_click_menu()
	local menu = awful.menu({
		items = {
			{
				"delete",
				function()
					self:delete_habit()
				end,
			},
			{
				"reset",
				function()
					self:reset_habit()
				end,
			},
		},
	})

	return menu
end

---Generate a button to increase success in the current habit
---@return table
function Habit:get_success_button()
	if self:is_already_checked() then
		return wibox.widget({
			{ text = "", align = "center", valign = "center", widget = wibox.widget.textbox },
			forced_height = button_size,
			forced_width = button_size,
			widget = wibox.widget.background,
		})
	else
		local button = wibox.widget({
			{ text = succes_icon, align = "center", valign = "center", widget = wibox.widget.textbox },
			forced_height = button_size,
			forced_width = button_size,
			widget = wibox.widget.background,
		})
		button:connect_signal("mouse::enter", function()
			button.bg = "#555555"
			button.fg = "#ffffff"
		end)
		button:connect_signal("mouse::leave", function()
			button.bg = nil
			button.fg = nil
		end)
		button:buttons(gears.table.join(awful.button({}, 1, nil, function()
			self:success()
			button:emit_signal_recursive("habit::update", self.data.title)
		end)))
		return button
	end
end

---Generate a button to increase fails in the current habit
---@return table
function Habit:get_fail_button()
	if self:is_already_checked() then
		return wibox.widget({
			{ text = "", align = "center", valign = "center", widget = wibox.widget.textbox },
			forced_height = button_size,
			forced_width = button_size,
			widget = wibox.widget.background,
		})
	else
		local button = wibox.widget({
			{ text = fail_icon, align = "center", valign = "center", widget = wibox.widget.textbox },
			forced_height = button_size,
			forced_width = button_size,
			widget = wibox.widget.background,
		})
		button:connect_signal("mouse::enter", function()
			button.bg = "#555555"
			button.fg = "#ffffff"
		end)
		button:connect_signal("mouse::leave", function()
			button.bg = nil
			button.fg = nil
		end)
		button:buttons(gears.table.join(awful.button({}, 1, nil, function()
			self:fail()
			button:emit_signal_recursive("habit::update", self.data.title)
		end)))
		return button
	end
end

---Get the progressbar for the success rate of the habit
---@return table
function Habit:get_succes_rate_bar()
	local succes_rate = self.data.successes / (self.data.successes + self.data.fails)
	local bar = wibox.widget.progressbar()
	bar.forced_height = bar_height
	bar.forced_width = bar_width
	bar.color = bar_fg_color
	bar.background_color = bar_bg_color
	bar.value = succes_rate
	return bar
end

---Get the icon related to the current status of the habit
---@return table
function Habit:get_status_icon()
	local text = self.data.last_check == "success" and "󰁞" or "󰁆"
	local color = self.data.last_check == "success" and beautiful.bg_focus or beautiful.bg_urgent
	local icon = wibox.widget.textbox()
	icon.markup = "<span foreground='" .. color .. "'>" .. text .. "</span>"
	return icon
end

function Habit:get_widget()
	self.title = wibox.widget.textbox(self.data.title)
	self.streaks_counter = wibox.widget.textbox("Streak " .. self.data.current_streak)
	self.missing_checks_icon = self:get_missing_checks_icon()
	self.success_button = self:get_success_button()
	self.fail_button = self:get_fail_button()
	self.progressbar = self:get_succes_rate_bar()
	self.status_icon = self:get_status_icon()
	self.right_click_menu = self:get_right_click_menu()

	local inner = wibox.widget({
		{
			{
				{ widget = self.title },
				{ widget = self.success_button },
				{ widget = self.fail_button },
				layout = wibox.layout.fixed.horizontal,
			},
			nil,
			{ widget = self.missing_checks_icon },
			expand = "inside",
			layout = wibox.layout.align.horizontal,
		},
		{
			{ widget = self.streaks_counter },
			nil,
			{ widget = self.status_icon },
			layout = wibox.layout.align.horizontal,
		},
		{ widget = self.progressbar },
		spacing = 3,
		layout = wibox.layout.fixed.vertical,
	})

	self.habit_widget = wibox.widget({
		{ widget = inner },
		widget = wibox.container.background,
		shape = gears.shape.rectangle,
		bg = widget_background,
	})

	self.habit_widget:connect_signal("mouse::enter", function()
		self.habit_widget.bg = widget_background_hover
	end)
	self.habit_widget:connect_signal("mouse::leave", function()
		self.habit_widget.bg = widget_background
	end)

	self.habit_widget:buttons(awful.util.table.join(awful.button({}, 3, function()
		self.right_click_menu:toggle()
	end)))

	return self.habit_widget
end

return Habit
