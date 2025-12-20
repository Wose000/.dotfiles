local wibox = require("wibox")
local helpers = require("modules.utils.helpers")

local icon = {
	mute = "",
	low = "",
	mid = "",
	high = "",
}

local icon_label = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "",
})

---get proper volume icon base on volume value
---@param volume number
---@return string
local function get_icon(volume)
	if volume == 0 then
		return icon.mute
	elseif volume > 0 and volume < 0.33 then
		return icon.low
	elseif volume > 0.33 and volume < 0.66 then
		return icon.mid
	elseif volume > 0.66 then
		return icon.high
	end
	return "err"
end

local audio_icon = wibox.widget({
	{ widget = icon_label },
	widget = wibox.container.margin,
	margins = 1,
})

awesome.connect_signal("audio_manager::volume_change", function(args)
	helpers.debug_log("called from singal")
	icon_label.markup = get_icon(args.value)
end)

return audio_icon
