local awful = require("awful")
local gears = require("gears")
local helpers = require("modules.utils.helpers")

-- returns 0 on stdout if there is internet connection
local cmd = "ping -c 1 google.com>&/dev/null; echo $?"

local status = {
	CONNECTED = "connected",
	DISCONNECTED = "disconnected",
}

local current_status = status.DISCONNECTED

local function check_internet_status()
	awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr, reason, exit_code)
		if exit_code == 0 then
			local new_status = ""
			if tonumber(stdout) == 0 then
				new_status = status.CONNECTED
			else
				new_status = status.DISCONNECTED
			end
			if new_status == "" or new_status ~= current_status then
				awesome.emit_signal("internet::" .. new_status)
				current_status = new_status
			end
		else
			helpers.debug_log(string.format("Error, exit_code: %d", exit_code))
		end
	end)
end

gears.timer({
	timeout = 5,
	call_now = true,
	autostart = true,
	callback = function()
		check_internet_status()
	end,
})
