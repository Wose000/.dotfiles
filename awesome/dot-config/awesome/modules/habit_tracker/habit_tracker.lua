local json = require("dkjson")
local wibox = require("wibox.init")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

local M = {}

local habits = {}

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

---@param icon string
---@param callback function
local function icon_button(icon, callback)
	local button = wibox.widget({
		{ text = icon, align = "center", valign = "center", widget = wibox.widget.textbox },
		forced_height = 30,
		forced_width = 30,
		widget = wibox.widget.background,
	})
	button:connect_signal("mouse::enter", function()
		button.bg = "#555555"
	end)

	button:connect_signal("mouse::enter", function()
		button.bg = nil
	end)
	button:buttons(gears.table.join(awful.button({}, 1, nil, callback)))

	return button
end

local function edit_habit_by_id(id, what_to_change)
	if what_to_change == "success" then
		habits[id].successes = habits[id].successes + 1
	end

	if what_to_change == "fail" then
		habits[id].fails = habits[id].fails + 1
	end
end

local promptbox = wibox.widget.textbox()

local function ask_for_habit_title(callback)
	awful.prompt.run({
		prompt = "New Habit Title: ",
		textbox = promptbox,
		exe_callback = function(input)
			if input and input ~= "" then
				callback(input)
			end
		end,
		history_path = awful.util.get_cache_dir() .. "/habit_add_history",
	})
end

local add_habit_button = wibox.widget({
	{
		text = "New Habit",
		widget = wibox.widget.textbox,
	},
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
	fg = beautiful.bg_focus,
	shape = gears.shape.rounded_rect,
	forced_height = 30,
	forced_width = 100,
})

add_habit_button:buttons(gears.table.join(awful.button({}, 1, function()
	ask_for_habit_title(function(title)
		print("New habit: " .. title)
	end)
end)))

---@param data table
---@param id integer
---@param update_callback function
local function build_habit_widget(data, id, update_callback)
	local succes_rate = data.successes / (data.successes + data.fails)
	return wibox.widget({
		{
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
			{
				icon_button("V", function()
					edit_habit_by_id(id, "success")
					update_callback()
				end),
				icon_button("X", function()
					edit_habit_by_id(id, "fail")
					update_callback()
				end),
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.fixed.vertical,
		},
		widget = wibox.container.margin,
		margin = 20,
	})
end

habits = get_habits_data()
function M.get_habits_widgets(callback)
	local layout = wibox.layout.fixed.vertical()
	for id, habit in ipairs(habits) do
		layout:add(build_habit_widget(habit, id, callback))
	end
	layout:add(promptbox)
	layout:add(add_habit_button)
	layout.forced_width = 300
	return layout
end

return M
