local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local Habit = require("modules.habit_tracker.habit")
local remote = "onedrive"
local path = ".data/habits.json"
local rclone = require("modules.utils.rclone")
local helpers = require("modules.utils.helpers")

local M = {}

M.habits = {}
M.habits_list = wibox.layout.fixed.vertical()

---Iterate the habits list to generate a table o data to be saved.
---@return table
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

---Return reference to Habit given his title
---@param title string
---@return Habit
local function get_habit_by_title(title)
	for _, habit in ipairs(M.habits) do
		if habit.data.title == title then
			return habit
		end
	end
	error(string.format("Error! could not find habit with title: %s", title))
end

---Return the index of the habit in the M.habits table
---@param habit Habit
---@return integer -1 means the object couldn't be found in the table
local function get_index(habit)
	for index, value in ipairs(M.habits) do
		if habit == value then
			return index
		end
	end
	return -1
end

local function init_callback(stdout)
	local decoded_data = helpers.decode_json(stdout)
	for _, habit_data in ipairs(decoded_data) do
		local habit = Habit.new(habit_data)
		table.insert(M.habits, habit)
		local habit_widget = habit:get_widget()
		M.habits_list:add(habit_widget)
	end

	M.habits_list:connect_signal("habit::update", function(_, title)
		local h = get_habit_by_title(title)
		--- NOTE: this process can be sped up, the widget is being reconstructed every time
		--- an update of the interested sub components would be faster.
		M.habits_list:replace_widget(h.widget, h:get_widget(), true)
	end)

	M.habits_list:connect_signal("habit::delete", function(_, title)
		local h = get_habit_by_title(title)
		local index = get_index(h)
		M.habits_list:remove_widgets(h.widget)
		table.remove(M.habits, index)
	end)
end

---Init function, loads data from the remote to then create habits widgets when ready.
function M.init()
	local command_table = {
		cmd = rclone.get_cat_command(path, remote),
		callback = init_callback,
	}
	rclone.add_command_to_queue(command_table)
end

local promptbox = wibox.widget.textbox()

local function ask_for_habit_title(add_habit_function)
	awful.prompt.run({
		prompt = "Title: ",
		textbox = promptbox,
		exe_callback = function(input)
			if input and input ~= "" then
				add_habit_function(input)
			end
		end,
		history_path = awful.util.get_cache_dir() .. "/habit_add_history",
	})
end

local function get_new_habit_button(add_habit_function)
	local button_bg = wibox.container.background()
	button_bg.bg = beautiful.bg_hover
	button_bg.shape = gears.shape.rounded_rect
	button_bg.forced_height = 15

	local new_habit_button = wibox.widget({
		{
			{
				widget = wibox.widget.textbox,
				markup = "New Habit",
				halign = "center",
			},
			widget = button_bg,
		},
		widget = wibox.container.margin,
		top = 10,
		bottom = 20,
		left = 5,
		right = 5,
	})

	new_habit_button:connect_signal("mouse::enter", function()
		button_bg.bg = beautiful.bg_minimize
	end)

	new_habit_button:connect_signal("mouse::leave", function()
		button_bg.bg = beautiful.bg_hover
	end)

	new_habit_button:buttons(gears.table.join(awful.button({}, 1, function()
		ask_for_habit_title(add_habit_function)
	end)))

	return new_habit_button
end

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
	local h = Habit.new(habit)
	table.insert(M.habits, h)
	M.habits_list:add(h:get_widget())
	save_data()
end

function M.create_widget()
	local w = wibox.layout.fixed.vertical()
	w:add(M.habits_list)
	w:add(promptbox)
	w:add(get_new_habit_button(add_new_habit))
	M.init()
	return w
end

return M
