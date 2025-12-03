local helpers = require("modules.utils.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local RedshiftButton = require("modules.control_center.redshift_control_button")

local M = {}

local box = wibox()
box.screen = screen[1]
box.ontop = true
box.width = 300
box.height = select(2, root.size())
box.visible = false

box:setup({
	{ layout = wibox.layout.fixed.horizontal },
	layout = wibox.layout.fixed.vertical,
})

function M.show_box()
	box.visible = not box.visible
end

require("modules.control_center.headphones_toggle")

return M
