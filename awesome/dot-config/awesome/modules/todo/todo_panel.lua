local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")
local rclone = require("modules.utils.rclone")
local helpers = require("modules.utils.helpers")

local remote = "onedrive"
local path = ".data/tasks.json"
local init_signal = "todo::data_loaded"
local Task = require("modules.todo.task")

local M = {}

M.tasks = {}

M.box = wibox()
M.box.screen = screen[1]
M.box.ontop = true
M.box.width = 300
M.box.height = select(2, root.size())

M.task_list = wibox.layout.fixed.vertical()

M.container = wibox.widget({
	{ layout = M.task_list },
	widget = wibox.container.background,
	bg = beautiful.bg_normal,
})

M.box:setup({
	widget = M.container,
})

local function emit_function(widget)
	return function(stdout)
		widget:emit_signal_recursive(init_signal, stdout)
	end
end

local function create_tasks(data_list)
	for _, task_data in ipairs(data_list) do
		local task = Task.new(task_data)
		table.insert(M.task_list, task)
	end
end

function M.init(listener_widget)
	listener_widget:connect_signal(init_signal, function(_, args)
		local decoded_data = helpers.decode_json(args)
		create_tasks(decoded_data)
	end)
	rclone.cat_with_signal(path, remote, emit_function(M.task_list))
end

function M.get_bar_icon()
	local bar_icon = wibox.widget.textbox()
	bar_icon.font = "JetBrainMono Nerd Font Mono 12"
	bar_icon.halign = "center"
	bar_icon.valign = "center"
	bar_icon.forced_width = 17
	bar_icon.markup = "<span color='" .. beautiful.accent .. "'></span>"

	bar_icon:buttons(awful.button({}, 1, function()
		M.box.visible = not M.box.visible
	end))
	return bar_icon
end

return M
