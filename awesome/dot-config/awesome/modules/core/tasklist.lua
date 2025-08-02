local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local M = {}

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

--- Takes a screen and return a tasklist widget for that screen
function M.get_tastklist_widget(s)
	return awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		style = {
			border_width = 1,
			border_color = "#777777",
			shape = gears.shape.rectangle,
		},
		layout = {
			spacing = 10,
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						{
							id = "icon_role",
							widget = wibox.widget.imagebox,
						},
						margins = 2,
						widget = wibox.container.margin,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 2,
				right = 2,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})
end

return M
