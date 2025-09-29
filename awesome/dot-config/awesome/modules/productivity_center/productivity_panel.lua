local helpers = require("modules.utils.helpers")
local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")

local todo = require("modules.todo.todo_panel")
local habit_tracker = require("modules.habit_tracker.habit_tracker")
local icon = ""

local M = {}

local function create_wibox()
	local title = wibox.widget({
		{ widget = wibox.widget.textbox, markup = "<b> Personal Panel</b>" },
		widget = wibox.container.background,
		bg = beautiful.bg01,
	})
	local panel = wibox()
	panel:setup({
		{
			{ widget = title },
			{ widget = wibox.widget.textbox, markup = "<b> Habit Tracker</b>", halign = "center" },
			{ widget = habit_tracker.create_widget() },
			{ widget = wibox.widget.textbox, markup = "<b> Todo Panel</b>", halign = "center" },
			{ widget = todo.get_todo_panel() },
			layout = wibox.layout.fixed.vertical,
		},
		widget = wibox.container.margin,
		margins = 5,
	})

	title:add_button(awful.button({}, 1, function()
		panel.visible = false
	end))
	panel.screen = screen[1]
	panel.ontop = true
	panel.width = 300
	panel.height = select(2, root.size())
	return panel
end

M.panel = create_wibox()

function M.get_bar_icon()
	local bar_icon = wibox.widget.textbox()
	bar_icon.font = beautiful.icon .. " 12"
	bar_icon.halign = "center"
	bar_icon.valign = "center"
	bar_icon.forced_width = 17
	bar_icon.markup = helpers.colorize_text(icon, beautiful.fg_normal)

	bar_icon:connect_signal("mouse::enter", function()
		bar_icon.font = beautiful.icon .. " 13"
		bar_icon.markup = "<b>" .. helpers.colorize_text(icon, beautiful.fg_focus) .. "</b>"
	end)

	bar_icon:connect_signal("mouse::leave", function()
		bar_icon.font = beautiful.icon .. " 12"
		bar_icon.markup = helpers.colorize_text(icon, beautiful.fg_normal)
	end)

	bar_icon:buttons(awful.button({}, 1, function()
		M.panel.visible = not M.panel.visible
	end))
	return bar_icon
end

return M
