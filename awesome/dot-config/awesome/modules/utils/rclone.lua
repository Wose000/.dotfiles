local json = require("dkjson")
local awful = require("awful")
local naughty = require("naughty")
local helpers = require("modules.utils.helpers")

local rclone = {}

local commands_queue = {}

function rclone.read(path, remote)
	return "rclone cat " .. remote .. ":" .. path
end

function rclone.get_rcat_commad(path, remote, data)
	return string.format("rclone rcat '%s:%s' << EOF\n%s\nEOF", remote, path, data)
end

local function run_command()
	if #commands_queue == 0 then
		helpers.debug_log("Called run command with an empty queue, returning")
		return
	end
	local command = commands_queue[1]
	awful.spawn.easy_async_with_shell(command, function(_, stderr, _, exit_code)
		if exit_code == 0 then
			table.remove(commands_queue, 1)
			helpers.debug_log("success running command: " .. command)
			if #commands_queue ~= 0 then
				run_command()
			end
		else
			helpers.debug_log("error: " .. stderr)
		end
	end)
end

function rclone.add_command_to_queue(command)
	table.insert(commands_queue, command)
	if #commands_queue == 1 then
		helpers.debug_log("running first command")
		run_command()
	else
		helpers.debug_log("put in queue")
	end
end

function rclone.cat_with_signal(path, remote, signal)
	awful.spawn.easy_async_with_shell(rclone.read(path, remote), function(stdout, stderr, _, exit_code)
		if exit_code == 0 then
			signal(stdout)
		else
			naughty.notification({
				title = "Error rclone cat",
				message = "tryed to call "
					.. rclone.read(path, remote)
					.. "\nexit_code: "
					.. exit_code
					.. "\nerr: "
					.. stderr,
			})
		end
	end)
end

function rclone.write_with_signal(path, remote, file, widget, signal)
	awful.spawn.easy_async_with_shell(rclone.write(path, remote, file), function(stdout, stderr, _, exit_code)
		if exit_code == 0 then
			widget:emit_signal(signal, stdout)
		else
			naughty.notification({
				title = "Error rclone cat",
				message = "tryed to call "
					.. rclone.write(path, remote, file)
					.. "\nexit_code: "
					.. exit_code
					.. "\nerr: "
					.. stderr,
			})
		end
	end)
end

return rclone
