local wibox = require("wibox")
local beautiful = require("beautiful")
local widget = {}

local icons = {
	mute = "",
	low = "",
	medium = "",
	high = "",
}

function widget.get_widget(widgets_args)
	return wibox.widget({
		{
			id = "icon",
			font = beautiful.icon .. " 11",
			widget = wibox.widget.textbox,
		},
		valign = "center",
		layout = wibox.container.place,
		set_volume_level = function(self, new_value)
			local volume_icon_name
			if self.is_muted then
				volume_icon_name = icons.mute
			else
				local new_value_num = tonumber(new_value)
				if new_value_num >= 0 and new_value_num < 33 then
					volume_icon_name = icons.low
				elseif new_value_num < 66 then
					volume_icon_name = icons.medium
				else
					volume_icon_name = icons.high
				end
			end
			self:get_children_by_id("icon")[1]:set_markup_silently(volume_icon_name)
		end,
		mute = function(self)
			self.is_muted = true
			self:get_children_by_id("icon")[1]:set_markup_silently(icons.mute)
		end,
		unmute = function(self)
			self.is_muted = false
		end,
	})
end

return widget

