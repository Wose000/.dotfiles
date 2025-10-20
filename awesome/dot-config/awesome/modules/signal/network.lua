local awful = require("awful")
local gears = require("gears")

local cmd = "ping -c 1 google.com>&/dev/null; echo $?"

local status = {
	CONNECTED = 1,
	DISCONNECTED = 2,
}

local current_status = status.DISCONNECTED

local function check_internet_status()
	awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr, reason, exit_code)
		if exit_code == 0 then
			local new_status = status.CONNECTED
			if new_status ~= current_status then
				current_status = new_status
				awesome.emit_signal("internet::connected")
			end
		else
			local new_status = status.DISCONNECTED
			if new_status ~= current_status then
				current_status = new_status
				awesome.emit_signal("internet::disconnected")
			end
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
