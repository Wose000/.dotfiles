local helpers = require("modules.utils.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local states = {
	unselected = 0,
	selected = 1,
}

local M = {
	icon = "󰂯",
	state = states.unselected,
	on_select_function = nil,
}

local background = wibox.widget({
	shape = gears.shape.squircle,
	bg = beautiful.inactive,
	widget = wibox.container.background,
})

background:connect_signal("mouse::enter", function()
	background.bg = beautiful.fg_normal
end)

background:connect_signal("mouse::leave", function()
	if M.state == states.unselected then
		background.bg = beautiful.inactive
	else
		background.bg = beautiful.accent
	end
end)

function M.get_button()
	local button = wibox.widget({
		{
			{
				{
					{
						markup = M.icon,
						widget = wibox.widget.textbox,
						valign = "center",
						halign = "center",
						font = beautiful.icon .. " 14",
					},
					margins = 3,
					widget = wibox.container.margin,
				},
				widget = background,
			},
			strategy = "min",
			width = 30,
			height = 30,
			widget = wibox.container.constraint,
		},
		margins = 10,
		widget = wibox.container.margin,
	})

	button:buttons(awful.button({}, 1, function()
		if M.state == states.unselected then
			M.state = states.selected
			background.bg = beautiful.accent
		else
			M.state = states.unselected
			background.bg = beautiful.inactive
		end
	end))

	return button
end

return M
