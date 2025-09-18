local wibox = require("wibox")
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

M.task_list = wibox.layout.fixed.vertical()

local function emit_function(widget)
	return function(stdout)
		widget:emit_signal_recursive(init_signal, stdout)
	end
end

local function create_tasks(data_list)
	for _, task_data in ipairs(data_list) do
		local task = Task.new(task_data)
		table.insert(M.tasks, task)
	end
end

local function update_remote_data()
	local data = {}
	for _, task in ipairs(M.tasks) do
		table.insert(data, { title = task.data.title, is_completed = task.data.is_completed })
	end
	local encoded_data = helpers.encode_json(data)
	rclone.add_command_to_queue(rclone.get_rcat_commad(path, remote, encoded_data))
end

---create a new task given the title
---@param title string
local function create_task(title)
	helpers.debug_log("called create_task(" .. title .. ")")
	local new_task = Task.new({ title = title, is_completed = false })
	local new_task_widget = new_task:get_widget()
	new_task_widget:add_button(awful.button({}, 1, function()
		new_task:toggle()
	end))
	table.insert(M.tasks, new_task)
	M.task_list:add(new_task_widget)
	update_remote_data()
end

local function create_widgets()
	for index, task in ipairs(M.tasks) do
		local widget = task:get_widget()
		widget:add_button(awful.button({}, 1, function()
			M.tasks[index]:toggle()
			update_remote_data()
		end))
		M.task_list:add(widget)
	end
end

function M.init(listener_widget)
	listener_widget:connect_signal(init_signal, function(_, args)
		local decoded_data = helpers.decode_json(args)
		create_tasks(decoded_data)
		create_widgets()
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

local promptbox = wibox.widget.textbox()
local function create_new_task()
	awful.prompt.run({
		prompt = "Title: ",
		textbox = promptbox,
		exe_callback = function(input)
			if input and input ~= "" then
				create_task(input)
			end
		end,
		history_path = awful.util.get_cache_dir() .. "/habit_add_history",
	})
end

local function delete_task(_, task)
	local success = M.task_list:remove_widgets(task.widget, true)
	if success then
		helpers.debug_log("success")
	end
	for index, value in ipairs(M.tasks) do
		if task == value then
			table.remove(M.tasks, index)
		end
	end
	update_remote_data()
end

function M.get_todo_panel()
	local add_task_block = wibox.layout.fixed.vertical()
	local addbutton = wibox.widget({
		{ widget = wibox.widget.textbox, markup = "Add Taks", halign = "center" },
		widget = wibox.container.background,
		bg = beautiful.bg_minimize,
		forced_height = 20,
		forced_width = 200,
	})
	addbutton:add_button(awful.button({}, 1, create_new_task))
	add_task_block:add(promptbox)
	add_task_block:add(addbutton)

	M.container = wibox.widget({
		{ { layout = M.task_list }, { layout = add_task_block }, layout = wibox.layout.fixed.vertical },
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
	})
	M.container:connect_signal("task::delete", function(widget, task)
		delete_task(widget, task)
	end)
	M.init(M.container)
	return M.container
end

-- M.box:setup({
-- 	widget = M.get_todo_panel(),
-- })

return M
