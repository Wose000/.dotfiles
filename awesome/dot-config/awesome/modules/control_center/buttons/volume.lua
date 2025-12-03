local helpers = require("modules.utils.helpers")
local pactl = require("awesome-wm-widgets.pactl-widget.pactl")

local sink = "@DEFAULT_SINK"
local icon = {
	high = "",
	mute = "",
}

local ControlButton = require("modules.control_center.control_button")

---@class VolumeButton : ControlButton
local VolumeButton = {}
VolumeButton.__index = VolumeButton
setmetatable(VolumeButton, { __index = ControlButton })

---Create Volume Button
---@return ControlButton|VolumeButton
function VolumeButton:new()
	local obj = ControlButton.new(self, icon.high)
	return setmetatable(obj, VolumeButton)
end

---@param self VolumeButton
function VolumeButton:on_release_callback()
	pactl.mute_toggle(sink)
	if self.button then
		self.icon_label.markup = icon.mute
	end
end

---@param self VolumeButton
function VolumeButton:on_select_callback()
	pactl.mute_toggle(sink)
	if self.button then
		self.icon_label.markup = icon.high
	end
end

return VolumeButton
