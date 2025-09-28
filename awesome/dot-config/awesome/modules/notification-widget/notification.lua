local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local Notification = {}

Notification.__index = Notification

function Notification.new(notification)
	local self = setmetatable({}, Notification)
	self.title = notification.title
	self.msg = notification.message
	self.dismiss_callback = function() end
	return self
end

function Notification:get_index(array)
	for index, value in ipairs(array) do
		if value == self then
			return index
		end
	end
	error("could not find this instance of Notification in the list")
end

function Notification:set_dismiss_callback(callback)
	self.dismiss_callback = callback
end

function Notification:dismiss()
	self.dismiss_callback()
end

function Notification:get_widget()
	local dismiss_button = wibox.widget.textbox()
	dismiss_button.markup = "DISMISS"
	dismiss_button.font = "Jet Brains Mono Nerd Font Mono 8"
	dismiss_button:connect_signal("mouse::enter", function()
		dismiss_button.markup = "<b>" .. "DISMISS" .. "</b>"
	end)

	dismiss_button:connect_signal("mouse::leave", function()
		dismiss_button.markup = "DISMISS"
	end)

	dismiss_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
		self:dismiss()
	end)))

	local time = os.date("%H:%M")
	local time_text = wibox.widget.textbox(time)
	local widget = wibox.widget({
		{
			{
				{
					{ widget = wibox.widget.textbox, markup = "<b>" .. self.title .. "</b>" },
					{ widget = wibox.widget.textbox, text = self.msg },
					{
						{ widget = dismiss_button },
						nil,
						{ widget = time_text },
						layout = wibox.layout.align.horizontal,
					},
					layout = wibox.layout.fixed.vertical,
				},
				widget = wibox.container.margin,
				top = 5,
				left = 5,
				right = 5,
			},
			widget = wibox.container.background,
			bg = beautiful.bg_hover,
		},
		widget = wibox.container.margin,
		top = 2,
		bottom = 2,
		left = 4,
		right = 4,
	})

	return widget
end

return Notification
