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

---@class ControlButton
---@field icon string
---@flied state integer
---@field background unknown
---@field icon_label unknown
local ControlButton = {}
ControlButton.__index = ControlButton

---Create new ControlButton
---@param icon string
---@return ControlButton
function ControlButton:new(icon)
	local obj = {}
	obj.icon = icon

	obj.background = wibox.widget({
		id = "bg",
		widget = wibox.container.background,
		shape = gears.shape.squircle,
		bg = beautiful.inactive,
	})

	obj.icon_label = wibox.widget({
		markup = obj.icon,
		valign = "center",
		halign = "center",
		font = beautiful.icon .. " 14",
		widget = wibox.widget.textbox,
	})
	obj.icon_label.markup = obj.icon
	obj.button = nil
	obj.state = STATES.unselected
	return setmetatable(obj, ControlButton)
end

---@param self ControlButton
function ControlButton:on_release_callback() end

---@param self ControlButton
function ControlButton:on_select_callback()
	helpers.debug_log("called on selected base")
end

---@param self ControlButton
function ControlButton:selection_toggle()
	if self.state == STATES.unselected then
		self.state = STATES.selected
		if self.on_select_callback then
			self:on_select_callback()
			helpers.debug_log("found functon on selected")
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

---@param self ControlButton
function ControlButton:unselected() end

---@param self ControlButton
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
						widget = self.icon_label,
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

	self.button:buttons(awful.button({}, 1, function()
		self:selection_toggle()
	end))

	if self.state == STATES.selected then
		self.background.bg = beautiful.accent
	else
		self.background.bg = beautiful.inactive
	end

	return self.button
end

return ControlButton
