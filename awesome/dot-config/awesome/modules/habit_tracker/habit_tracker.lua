local json = require("dkjson")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local module_path = gears.filesystem.get_configuration_dir() .. "modules/habit_tracker/"
local module_data_path = module_path .. "data/"
local data_path = module_data_path .. "habits.json"
local Habit = require("modules.habit_tracker.habit")

local M = {}

local L = require("modules.utils.logging")

---@return table
local function load_habits_data()
	local file = io.open(data_path, "r")
	local habits_table = {}
	L.log(gears.filesystem.get_configuration_dir())
	if file then
		habits_table = file:read("*a")
		file:close()
	end
	local data, _, err = json.decode(habits_table)
	if err then
		error(err)
	end
	if type(data) == "table" then
		return data
	else
		error("expected a table as json.decode output found " .. type(data))
	end
end

local function save_data(data)
	local data_as_json = json.encode(data, { indent = true })
	local file = io.open(data_path, "w")
	if file and type(data_as_json) == "string" then
		file:write(data_as_json)
		file:close()
	else
		error("Error: could not open file for writing")
	end
end

local promptbox = wibox.widget.textbox()

local function ask_for_habit_title(callback, update_callback)
	awful.prompt.run({
		prompt = "Title: ",
		textbox = promptbox,
		exe_callback = function(input)
			if input and input ~= "" then
				callback(input, update_callback)
			end
		end,
		history_path = awful.util.get_cache_dir() .. "/habit_add_history",
	})
end

local habits_data = load_habits_data()

local function get_habits()
	local result = {}
	for _, habit in ipairs(habits_data) do
		local h = Habit.new(habit)
		result[habit.title] = h
	end
	return result
end

local habits = get_habits()

function M.process_habits_for_notifications()
	for title, habit in pairs(habits) do
		local needs_check = false
		local is_streak_going_well = false
		local checks_needed = habit:checks_needed()

		if checks_needed > 2 then
			needs_check = true
		end

		if habit.data.current_streak > 7 then
			is_streak_going_well = true
		end

		if needs_check then
			naughty.notification({
				title = title .. " needs to be checked ",
				timeout = 0,
				category = "habit_tracker",
				message = "This habit hasn't been checked in " .. checks_needed .. " days.",
				width = 300,
			})
		end

		if is_streak_going_well then
			naughty.notification({
				title = "Hot streak! 󰈸",
				timeout = 0,
				category = "habit_tracker",
				message = "You're doing really well with "
					.. title
					.. " keep the focus and the good work master!\nAchieve this goal also today",
				width = 300,
			})
		end
	end
end

local function get_widgets()
	local result = {}
	for title, habit in pairs(habits) do
		result[title] = habit:get_widget()
	end
	return result
end

local habits_widgets = get_widgets()

local add_habit_button = wibox.widget({
	{
		text = " New Habit",
		widget = wibox.widget.textbox,
	},
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
	fg = beautiful.bg_focus,
	shape = gears.shape.rectangle,
	forced_height = 30,
	forced_width = 100,
})

add_habit_button:connect_signal("mouse::enter", function()
	add_habit_button.bg = beautiful.bg_minimize
end)

add_habit_button:connect_signal("mouse::leave", function()
	add_habit_button.bg = beautiful.bg_normal
end)

local function add_new_habit(title, update_callback)
	local habit = {
		title = title,
		current_streak = 0,
		best_streak = 0,
		last_check_date = "",
		last_check = "",
		successes = 0,
		fails = 0,
	}
	table.insert(habits_data, habit)
	save_data(habits_data)
	update_callback()
end

local function get_habits_widgets()
	local layout = wibox.layout.fixed.vertical()
	for _, widget in pairs(habits_widgets) do
		layout:add(widget)
	end
	layout:add(promptbox)
	layout:add(add_habit_button)
	layout.forced_width = 300
	layout:connect_signal("habit::update", function(_, title)
		local new_habit_widget = habits[title]:get_widget()
		layout:replace_widget(habits_widgets[title], new_habit_widget, true)
		habits_widgets[title] = new_habit_widget
		save_data(habits_data)
	end)
	layout:connect_signal("habit::delete", function(_, title)
		layout:replace_widget(habits_widgets[title], wibox.widget({}), true)
		habits[title] = nil
		habits_data[title] = nil
		habits_widgets[title] = nil
		save_data(habits_data)
	end)
	return layout
end

M.bar_icon = wibox.widget({
	widget = wibox.widget.textbox,
	text = "",
	font = "Jet Brains Mono Nerd Font Mono 17",
	align = "center",
	valign = "center",
})

local popup = awful.popup({
	screen = screen[1],
	widget = get_habits_widgets(),
	ontop = true,
	visible = false,
	placement = awful.placement.right,
	shape = gears.shape.rounded_rect,
	hide_on_right_click = false,
})

local function update_popup()
	popup.widget = get_habits_widgets()
end

M.bar_icon:buttons(awful.button({}, 1, function()
	popup.widget = get_habits_widgets()
	popup.visible = not popup.visible
end))

add_habit_button:buttons(gears.table.join(awful.button({}, 1, function()
	ask_for_habit_title(add_new_habit, update_popup)
end)))

return M
