local json = require("dkjson")
local awful = require("awful")
local naughty = require("naughty")

local rclone = {}

function rclone.read(path, remote)
	return "rclone cat " .. remote .. ":" .. path
end

function rclone.write(path, remote, file)
	return "rclone copy " .. file .. " " .. remote .. ":" .. path
end

function rclone.cat_with_signal(path, remote, signal)
	awful.spawn.easy_async_with_shell(rclone.read(path, remote), function(stdout, stderr, _, exit_code)
		if exit_code == 0 then
			naughty.notification({ title = "called", message = stdout })
			signal()
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
