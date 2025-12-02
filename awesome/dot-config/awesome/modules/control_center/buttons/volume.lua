local pactl = require("awesome-wm-widgets.pactl-widget.pactl")

local sink = "@DEFAULT_SINK"
local icon = {
	high = "",
	mute = "",
}

local Button = require("modules.control_center.control_button")
local VolumeButton = setmetatable({}, Button)
VolumeButton.__index = VolumeButton

function VolumeButton:on_release_callback()
	pactl.mute_toggle(sink)
	if self.button then
		local i = self.button:get_children_by_id("icon")
		i.markup = icon.high
	end
end

function VolumeButton:on_select_callback()
	pactl.mute_toggle(sink)

	if self.button then
		local i = self.button:get_children_by_id("icon")
		i.markup = icon.mute
	end
end

return VolumeButton
