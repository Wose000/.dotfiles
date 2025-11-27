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

local ControlButton = require("modules.control_center.control_button")

local control_button = ControlButton.new("x", nil, nil)
local button = control_button:get_button()

local redshift_button = require("modules.control_center.redshift_control_button")

box:setup({
	{ { widget = button }, { widget = redshift_button }, layout = wibox.layout.fixed.horizontal },
	layout = wibox.layout.fixed.vertical,
})

function M.show_box()
	box.visible = not box.visible
end

return M
