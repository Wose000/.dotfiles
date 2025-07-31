local json = require("dkjson")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local date = require("date")
local data_path = "/home/wose/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/data/habits.json"
local Habit = require("modules.habit_tracker.habit")

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

---@return table
local function load_habits_data()
	local file = io.open(data_path, "r")
	local habits_table = {}
	if file then
		habits_table = file:read("*a")
		file:close()
	end
	local data, _, err = json.decode(habits_table)
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

local count = 0
for title, habit in pairs(habits) do
	log(title .. " -> habit class data: " .. habit.data.title)
	count = count + 1
end
log(count)

local function get_widgets()
	local result = {}
	for title, habit in pairs(habits) do
		log("iterating in get_widgets()")
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
	layout:connect_signal("habit::update", function(widget, title)
		-- layout:replace_widget(widget, habits[title]:get_widget())
	end)
	return layout
end

local bar_icon = wibox.widget({
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

awesome.connect_signal("habits::habit_updated", function()
	log("listening to signal")
end)

local function update_popup()
	popup.widget = get_habits_widgets()
end

bar_icon:buttons(awful.button({}, 1, function()
	popup.widget = get_habits_widgets()
	popup.visible = not popup.visible
end))

add_habit_button:buttons(gears.table.join(awful.button({}, 1, function()
	ask_for_habit_title(add_new_habit, update_popup)
end)))

return bar_icon
