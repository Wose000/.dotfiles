local helpers = require("modules.utils.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

---@enum states
local STATES = {
	unselected = 0,
	selected = 1,
}

---Base class to generate control buttons
---@class ControlButton
---@field icon string icon for the button
---@field on_selected_function fun()|nil to be called on button selected
---@field on_released_function fun()|nil to be called on button deselected
---@field state states # button state, unselected = 0, selected = 1
local ControlButton = {}

ControlButton.__index = ControlButton

---Constructor for ControlButton
---@param icon string Icon that's going to be displayed on the button
---@param on_selected_function fun()|nil callback for on_button_selected
---@param on_released_function fun()|nil callback for on_button_released
---@return ControlButton # returns a new istance of control button
function ControlButton.new(icon, on_selected_function, on_released_function)
	---@class ControlButton
	local self = setmetatable({}, ControlButton)

	self.icon = icon

	self.on_select_callback = on_selected_function

	self.on_release_callback = on_released_function

	self.state = STATES.unselected

	return self
end

---Return the button
---@this ControlButton
function ControlButton:get_button()
	local background = wibox.widget({
		shape = gears.shape.squircle,
		bg = beautiful.inactive,
		widget = wibox.container.background,
	})

	background:connect_signal("mouse::enter", function()
		background.bg = beautiful.fg_normal
	end)

	background:connect_signal("mouse::leave", function()
		if self.state == STATES.unselected then
			background.bg = beautiful.inactive
		else
			background.bg = beautiful.accent
		end
	end)

	local button = wibox.widget({
		{
			{
				{
					{
						markup = self.icon,
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
		if self.state == STATES.unselected then
			self.state = STATES.selected
			if self.on_select_callback then
				self.on_select_callback()
			end
			background.bg = beautiful.accent
		else
			self.state = STATES.unselected
			if self.on_release_callback then
				self.on_release_callback()
			end
			background.bg = beautiful.inactive
		end
	end))

	return button
end

return ControlButton
