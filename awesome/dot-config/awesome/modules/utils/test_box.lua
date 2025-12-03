local wibox = require("wibox")

local RedshiftButton = require("modules.control_center.redshift_control_button")
local VolumeButton = require("modules.control_center.buttons.volume")

local M = {}

local box = wibox()
box.screen = screen[1]
box.ontop = true
box.width = 300
box.height = select(2, root.size())
box.visible = false

local rs_button = RedshiftButton:new()
local vol_button = VolumeButton:new()

box:setup({
	{
		{ widget = vol_button:get_button() },
		{ widget = rs_button:get_button() },
		layout = wibox.layout.fixed.horizontal,
	},
	layout = wibox.layout.fixed.vertical,
})

function M.show_box()
	box.visible = not box.visible
end

require("modules.control_center.headphones_toggle")

return M
