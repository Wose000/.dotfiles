local wibox = require("wibox.init")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local habits_fun = require("modules.habit_tracker.habit_tracker")

local bar_icon = wibox.widget({
	widget = wibox.widget.textbox,
	text = "M",
	align = "center",
	valign = "center",
})

local popup = awful.popup({
	screen = screen[1],
	widget = habits_fun.get_habits_widgets(),
	border_color = "#000000",
	border_width = 0,
	ontop = true,
	visible = false,
	shape = gears.shape.rounded_rect,
	hide_on_right_click = false,
})

local function update_popup()
	popup.widget = habits_fun.get_habits_widgets(update_popup)
end

bar_icon:buttons(awful.button({}, 1, function()
	popup.widget = habits_fun.get_habits_widgets(update_popup)
	popup.visible = not popup.visible
end))

return bar_icon
