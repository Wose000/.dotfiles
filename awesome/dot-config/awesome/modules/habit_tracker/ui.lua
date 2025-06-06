local wibox = require("wibox.init")
local awful = require("awful")
local gears = require("gears")

local habits_fun = require("modules.habit_tracker.habit_tracker")

local bar_icon = wibox.widget({
	widget = wibox.widget.textbox,
	text = "H",
	align = "center",
	valign = "center",
})

bar_icon:buttons(awful.button({}, 1, function()
	local popup = awful.popup({
		screen = screen[1],
		widget = habits_fun.get_habits_widgets(),
		border_color = "#000000",
		border_width = 2,
		placement = awful.placement.top_right,
		ontop = true,
		visible = false,
		shape = gears.shape.rounded_rect,
	})
	popup.visible = not popup.visible
end))

return bar_icon
