local helpers = require("modules.utils.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local todo = require("modules.todo.todo_panel")
local habit_tracker = require("modules.habit_tracker.habit_tracker")

local M = {}

local function create_wibox()
	local panel = wibox()
	panel:setup({
		{
			{ widget = habit_tracker.create_widget() },
			{ widget = todo.get_todo_panel() },
			layout = wibox.layout.fixed.vertical,
		},
		widget = wibox.container.margin,
		margins = 5,
	})

	panel.screen = screen[1]
	panel.ontop = true
	panel.width = 300
	panel.height = select(2, root.size())
	return panel
end

M.panel = create_wibox()

function M.get_bar_icon()
	local bar_icon = wibox.widget.textbox()
	bar_icon.font = "JetBrainMono Nerd Font Mono 12"
	bar_icon.halign = "center"
	bar_icon.valign = "center"
	bar_icon.forced_width = 17
	bar_icon.markup = helpers.colorize_text("", beautiful.fg_normal)

	bar_icon:buttons(awful.button({}, 1, function()
		M.panel.visible = not M.panel.visible
	end))
	return bar_icon
end

return M
