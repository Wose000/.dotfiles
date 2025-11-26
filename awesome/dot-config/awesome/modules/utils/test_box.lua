local helpers = require("modules.utils.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")

local M = {}

local box = wibox()
box.screen = screen[1]
box.ontop = true
box.width = 300
box.height = select(2, root.size())
box.visible = false

local button = require("modules.control_center.control_button").get_button()
box:setup({
	{ { widget = button }, layout = wibox.layout.fixed.horizontal },
	layout = wibox.layout.fixed.vertical,
})

function M.show_box()
	box.visible = not box.visible
end

return M
