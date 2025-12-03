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

function ControlButton:new(icon)
	---@class ControlButton
	local obj = setmetatable({}, self)
	obj.icon = icon
	obj.state = STATES.unselected
	obj.background = wibox.widget({
		shape = gears.shape.squircle,
		bg = beautiful.inactive,
		widget = wibox.container.background,
	})

	helpers.debug_log("Called from base class!")
	return obj
end

function ControlButton:selection_toggle()
	if self.state == STATES.unselected then
		self.state = STATES.selected
		if self.on_select_callback then
			self:on_select_callback()
		end
		self.background.bg = beautiful.accent
	else
		self.state = STATES.unselected
		if self.on_release_callback then
			self:on_release_callback()
		end
		self.background.bg = beautiful.inactive
	end
end

function ControlButton:unselected() end

function ControlButton:on_release_callback() end

function ControlButton:on_select_callback() end
---Return the button
---@this ControlButton
function ControlButton:get_button()
	self.background:connect_signal("mouse::enter", function()
		self.background.bg = beautiful.fg_normal
	end)

	self.background:connect_signal("mouse::leave", function()
		if self.state == STATES.unselected then
			self.background.bg = beautiful.inactive
		else
			self.background.bg = beautiful.accent
		end
	end)

	self.button = wibox.widget({
		{
			{
				{
					{
						markup = self.icon,
						id = "icon",
						widget = wibox.widget.textbox,
						valign = "center",
						halign = "center",
						font = beautiful.icon .. " 14",
					},
					margins = 3,
					widget = wibox.container.margin,
				},
				widget = self.background,
			},
			strategy = "min",
			width = 30,
			height = 30,
			widget = wibox.container.constraint,
		},
		margins = 10,
		widget = wibox.container.margin,
	})

	self.button:buttons(awful.button({}, 1, self.selection_toggle))

	return self.button
end

return ControlButton
