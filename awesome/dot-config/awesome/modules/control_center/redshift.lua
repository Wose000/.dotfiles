local awful = require("awful")

local M = {
	temperature = 4500,
}

---get the cmd to set reshift with given temperature
---@param temperature integer temperature value <LeftMouse>
---@return string
local function get_cmd_activate(temperature)
	if temperature < 1000 then
		temperature = 1000
	elseif temperature > 25000 then
		temperature = 25000
	end
	return string.format("redshift -P -O %d", temperature)
end

---Reset screen gamma
---@return string command to reset screen gamma
local function get_reset_cmd()
	return [[redshift -x]]
end

---run redshift one shot mode
---@param temperature integer|nil value of temperature 1000 < temperature < 25000
function M.enable(temperature)
	if not temperature then
		temperature = M.temperature
	end
	awful.spawn.with_shell(get_cmd_activate(temperature))
end

---Reset screen gamma
function M.disable()
	awful.spawn.with_shell(get_reset_cmd())
end

return M
