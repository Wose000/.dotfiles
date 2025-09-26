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
local remote = "onedrive"
local path = ".data/habits.json"
local init_signal = "habits::data_loaded"
local rclone = require("modules.utils.rclone")
local helpers = require("modules.utils.helpers")
local M = {}

M.habits = {}
M.habits_list = wibox.layout.fixed.vertical()

---@return table
local function load_habits_data()
	local file = io.open(data_path, "r")
	local habits_table = {}
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

local function get_data_table()
	local res = {}
	for _, habit in ipairs(M.habits) do
		table.insert(res, habit.data)
	end
	return res
end

local function save_data()
	local data = get_data_table()
	local encoded_data = helpers.encode_json(data)
	local command_table = { cmd = rclone.get_rcat_commad(path, remote, encoded_data), callback = nil }
	rclone.add_command_to_queue(command_table)
end

local function init_callback(stdout)
	local decoded_data = helpers.decode_json(stdout)
	for _, habit_data in ipairs(decoded_data) do
		local habit = Habit.new(habit_data)
		table.insert(M.habits, habit)
		local habit_widget = habit:get_widget()
		M.habits_list:add(habit_widget)
		M.habits_list:connect_signal("habit::update", function(_, title)
			M.habits_list:replace_widget(habit.widget, habit:get_widget(), true)
			save_data()
		end)
		-- 		local function on_delete_habit_callback(_, title)
		-- 			table.remove(M.habits, habit)
		-- 			save_data(habits_data)
		-- 			layout:replace_widget(habits_widgets[title], wibox.widget({}), true)
		-- 			habits[title] = nil
		-- 			habits_widgets[title] = nil
		-- 		end
		-- 		layout:connect_signal("habit::delete", on_delete_habit_callback)
	end
end

function M.init()
	-- I could use stdout to populate the widget from the callback function.
	-- Why do I emit a signal?
	local command_table = {
		cmd = rclone.get_cat_command(path, remote),
		callback = init_callback,
	}
	rclone.add_command_to_queue(command_table)
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

local function get_habit_index_by_title(title)
	for i, data in ipairs(habits_data) do
		if data.title == title then
			return i
		end
	end
end

local habits = get_habits()

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
		widget = wibox.widget.textbox,
		markup = "New Habit",
		halign = "center",
	},
	widget = wibox.container.background,
	bg = beautiful.bg_minimize,
	shape = gears.shape.rectangle,
	forced_height = 20,
	forced_width = 200,
})

local function get_habits_widgets()
	local layout = wibox.layout.fixed.vertical()
	for _, widget in pairs(habits_widgets) do
		layout:add(widget)
	end
	layout.forced_width = 300
	layout:connect_signal("habit::update", function(_, title)
		local new_habit_widget = habits[title]:get_widget()
		layout:replace_widget(habits_widgets[title], new_habit_widget, true)
		habits_widgets[title] = new_habit_widget
		save_data(habits_data)
	end)
	local function on_delete_habit_callback(_, title)
		table.remove(habits_data, get_habit_index_by_title(title))
		save_data(habits_data)
		layout:replace_widget(habits_widgets[title], wibox.widget({}), true)
		habits[title] = nil
		habits_widgets[title] = nil
	end
	layout:connect_signal("habit::delete", on_delete_habit_callback)
	return layout
end

local habit_tracker = get_habits_widgets()

local function add_new_habit(title)
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
	local h = Habit.new(habit)
	habits[title] = h
	local widget = h:get_widget()
	M.habits_list:add(widget)
	save_data(habits_data)
end

add_habit_button:connect_signal("mouse::enter", function()
	add_habit_button.bg = beautiful.accent
end)

add_habit_button:connect_signal("mouse::leave", function()
	add_habit_button.bg = beautiful.bg_minimize
end)

add_habit_button:buttons(gears.table.join(awful.button({}, 1, function()
	ask_for_habit_title(add_new_habit)
end)))

function M.create_widget()
	local w = wibox.layout.fixed.vertical()
	w:add(M.habits_list)
	w:add(promptbox)
	w:add(add_habit_button)
	M.init()
	return w
end

return M
