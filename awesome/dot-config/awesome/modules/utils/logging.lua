local gears = require("gears")
local L = {}
local log_path = gears.filesystem.get_configuration_dir() .. "modules/habit_tracker/data/log.txt"

function L.log(msg)
	local file = io.open(log_path, "a")
	if not file then
		return
	end
	local formatted_datetime = os.date("%Y-%m-%d %H:%M:%S")
	file:write(formatted_datetime .. ": " .. msg .. "\n")
	file:close()
end

return L
