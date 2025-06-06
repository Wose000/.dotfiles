local json = require("dkjson")
local wibox = require("wibox.init")
local beautiful = require("beautiful")

local M = {}

local function get_habits_data()
	local file = io.open("/home/wose/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/data/habits.json", "r")
	local habits_table = {}
	if file then
		habits_table = file:read("*a")
		file:close()
	end
	local data, _, err = json.decode(habits_table)
	return data
end

local function get_habit_widget(data)
	local succes_rate = data.successes / (data.successes + data.fails)
	local w = {
		{
			text = data.title,
			widget = wibox.widget.textbox,
		},
		{
			value = succes_rate,
			forced_height = 10,
			forced_width = 100,
			color = beautiful.bg_focus,
			background_color = beautiful.bg_normal,
			widget = wibox.widget.progressbar,
		},
		layout = wibox.layout.fixed.vertical,
		margins = 4,
		widget = wibox.container.margin,
	}
	return w
end

function M.get_habits_widgets()
	local habits = get_habits_data()
	local w = {}
	for i, habit in ipairs(habits) do
		table.insert(w, get_habit_widget(habit))
	end
	w.layout = wibox.layout.fixed.vertical
	w.margins = 4
	w.widget = wibox.container.margin
	return w
end

return M
