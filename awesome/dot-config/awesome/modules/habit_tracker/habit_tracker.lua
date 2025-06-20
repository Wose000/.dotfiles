local json = require("dkjson")
local wibox = require("wibox.init")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local date = require("date")

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

local function save_data(data)
	local data_as_json = json.encode(data, { indent = true })
	local file = io.open("/home/wose/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/data/habits.json", "w")
	if file then
		file:write(data_as_json)
		file:close()
	else
		print("Error: could not open file fro writing")
	end
end

---@param already_checked boolean
---@param icon string
---@param callback function
local function icon_button(already_checked, icon, callback)
	local button = {}
	if not already_checked then
		button = wibox.widget({
			{ text = icon, align = "center", valign = "center", widget = wibox.widget.textbox },
			forced_height = 30,
			forced_width = 30,
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
		button:buttons(gears.table.join(awful.button({}, 1, nil, callback)))
	else
		button = wibox.widget({
			{ text = "", align = "center", valign = "center", widget = wibox.widget.textbox },
			forced_height = 30,
			forced_width = 30,
			widget = wibox.widget.background,
		})
	end

	return button
end

local function get_new_date(last_update_date)
	local correct_format_date = string.gsub(last_update_date, "-", " ")
	local curr_date = date(correct_format_date)
	curr_date:adddays(1)
	return curr_date:fmt("%Y-%m-%d")
end

local function edit_habit_by_id(habit, what_to_change)
	if what_to_change == "success" then
		habit.successes = habit.successes + 1
		habit.last_check_date = get_new_date(habit.last_check_date)
		-- in case last check was succes increase streak and check if new best streak
		if habit.last_check == "success" then
			habit.current_streak = habit.current_streak + 1
			if habit.current_streak >= habit.best_streak then
				habit.best_streak = habit.current_streak
			end
		-- in case last check was fail start a new streak
		elseif habit.last_check == "fail" then
			habit.current_streak = 1
			if habit.current_streak >= habit.best_streak then
				habit.best_streak = habit.current_streak
			end
		-- last check was empty this should be happen only on new habits
		else
			habit.current_streak = 1
			habit.best_streak = habit.current_streak
		end
		habit.last_check = "success"
	end

	if what_to_change == "fail" then
		habit.fails = habit.fails + 1
		habit.last_check_date = get_new_date(os.date("%Y-%m-%d"))
		-- in case last check was succes break the streak
		if habit.last_check == "success" then
			habit.current_streak = 0
		end
		habit.last_check = "fail"
	end
	save_data(habits)
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

---@param habit table
---@param id integer
---@param update_callback function
local function build_habit_widget(habit, id, update_callback)
	local succes_rate = habit.successes / (habit.successes + habit.fails)
	local function already_checked()
		local today_date = os.date("%Y-%m-%d")
		if habit.last_check_date == today_date then
			return true
		end
		return false
	end
	return wibox.widget({
		{
			{
				{
					{
						{
							{
								text = habit.title,
								widget = wibox.widget.textbox,
							},
							{
								icon_button(already_checked(), "󰸞", function()
									edit_habit_by_id(habit, "success")
									update_callback()
								end),
								icon_button(already_checked(), "", function()
									edit_habit_by_id(habit, "fail")
									update_callback()
								end),
								layout = wibox.layout.fixed.horizontal,
							},
							layout = wibox.layout.fixed.horizontal,
						},
						{
							value = succes_rate,
							forced_height = 10,
							forced_width = 100,
							color = beautiful.bg_focus,
							background_color = beautiful.bg_minimize,
							widget = wibox.widget.progressbar,
						},
						{
							text = "Current streak: " .. habit.current_streak,
							widget = wibox.widget.textbox,
						},
						layout = wibox.layout.fixed.vertical,
					},
					widget = wibox.container.margin,
					top = 0,
					left = 5,
					right = 5,
					bottom = 4,
				},
				widget = wibox.container.background,
				shape = gears.shape.rectangle,
				bg = beautiful.bg_normal,
			},
			widget = wibox.container.margin,
			top = 2.5,
			left = 5,
			right = 5,
			bottom = 5,
		},
		widget = wibox.container.background,
		bg = beautiful.border_normal,
	})
end

habits = get_habits_data()

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
	table.insert(habits, habit)
	save_data(habits)
	update_callback()
end

local function get_habits_widgets(callback)
	local layout = wibox.layout.fixed.vertical()
	for id, habit in ipairs(habits) do
		layout:add(build_habit_widget(habit, id, callback))
	end
	layout:add(promptbox)
	layout:add(add_habit_button)
	layout.forced_width = 300
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

local function update_popup()
	popup.widget = get_habits_widgets(update_popup)
end

bar_icon:buttons(awful.button({}, 1, function()
	popup.widget = get_habits_widgets(update_popup)
	popup.visible = not popup.visible
end))

add_habit_button:buttons(gears.table.join(awful.button({}, 1, function()
	ask_for_habit_title(add_new_habit, update_popup)
end)))

return bar_icon
