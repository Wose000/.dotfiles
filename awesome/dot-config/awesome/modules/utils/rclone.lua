local awful = require("awful")
local helpers = require("modules.utils.helpers")

local rclone = {}

local commands_queue = {}

function rclone.get_rcat_commad(path, remote, data)
	return string.format("rclone rcat '%s:%s' << EOF\n%s\nEOF", remote, path, data)
end

function rclone.get_cat_command(path, remote)
	return string.format("rclone cat %s:%s", remote, path)
end

local function run_command()
	if #commands_queue == 0 then
		helpers.debug_log("Called run command with an empty queue, returning")
		return
	end
	local command_table = commands_queue[1]
	awful.spawn.easy_async_with_shell(command_table.cmd, function(stdout, stderr, _, exit_code)
		if exit_code == 0 then
			if command_table.callback then
				command_table.callback(stdout)
			end
			table.remove(commands_queue, 1)
			if #commands_queue ~= 0 then
				run_command()
			end
		else
			helpers.debug_log("error: " .. stderr)
		end
	end)
end

---Add command to the queue of commands to be executed, if a callback is passedd in the table
---the callback is executed when the cmd returns, stdou is passed to the callback
---@param command table must be in the form command {cmd = string, callback = function|nil}
function rclone.add_command_to_queue(command)
	print(string.format("addedd command %s", command.cmd))
	table.insert(commands_queue, command)
	if #commands_queue == 1 then
		run_command()
	end
end

return rclone
