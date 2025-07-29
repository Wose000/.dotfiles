local json = require("dkjson")
local wibox = require("wibox.init")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local date = require("date")
local data_path = "/home/wose/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/data/habits.json"
local habits = {}

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
local function get_habits_data()
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

---@param already_checked boolean
---@param icon string
---@param callback function
local function icon_button(already_checked, icon, callback)
	local button = {}
	if not already_checked then
		button = wibox.widget({
			{ text = icon, align = "center", valign = "center", widget = wibox.widget.textbox },
			forced_height = 20,
			forced_width = 20,
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
			forced_height = 20,
			forced_width = 20,
			widget = wibox.widget.background,
		})
	end

	return button
end

local function get_new_date(last_update_date)
	if last_update_date == "" then
		return os.date("%Y-%m-%d")
	end
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

		habit.last_check_date = get_new_date(habit.last_check_date)
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

local naughty = require("naughty")

local function missing_checks_icon(last_check_date)
	if last_check_date == "" then
		return
	end
	local fmt_date = string.gsub(last_check_date, "-", " ")
	local d = date.diff(date(), date(fmt_date))
	local checks_needed = math.floor(d:spandays())
	if checks_needed == 0 then
		naughty.notification({ title = "habit checkd", message = "this habit is checkd" })
	end
	local text = checks_needed > 0 and "x" .. checks_needed .. " 󰀦" or ""
	return wibox.widget({
		text = text,
		widget = wibox.widget.textbox,
	})
end

local function status_icon(last_check)
	local text = last_check == "success" and "󰁞" or "󰁆"
	local color = last_check == "success" and beautiful.bg_focus or beautiful.bg_urgent
	local icon = wibox.widget.textbox()
	icon.markup = "<span foreground='" .. color .. "'>" .. text .. "</span>"
	return icon
end

---@param habit table
---@param update_callback function
local function build_habit_widget(habit, update_callback)
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
								{
									text = habit.title,
									widget = wibox.widget.textbox,
								},
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
							nil,
							missing_checks_icon(habit.last_check_date),
							expand = "inside",
							layout = wibox.layout.align.horizontal,
						},
						{
							{
								text = "Streak: " .. habit.current_streak,
								widget = wibox.widget.textbox,
							},
							nil,
							status_icon(habit.last_check),
							layout = wibox.layout.align.horizontal,
						},
						{
							value = succes_rate,
							forced_height = 3,
							forced_width = 100,
							color = beautiful.bg_focus,
							background_color = beautiful.bg_minimize,
							widget = wibox.widget.progressbar,
						},
						spacing = 3,
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
			top = 1,
			left = 2,
			right = 2,
			bottom = 2,
		},
		widget = wibox.container.background,
		bg = beautiful.bg_normal,
	})
end

habits = get_habits_data()

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
	table.insert(habits, habit)
	save_data(habits)
	update_callback()
end

local function get_habits_widgets(callback)
	local layout = wibox.layout.fixed.vertical()
	for _, habit in ipairs(habits) do
		layout:add(build_habit_widget(habit, callback))
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
