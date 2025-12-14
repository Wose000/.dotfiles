local json = require("dkjson")
local awful = require("awful")
local helpers = require("modules.utils.helpers")

local paclt_list_cmd = [[pactl -f json list sinks]]
local default_sink = "alsa_output.pci-0000_00_1f.3.analog-stereo"
local default_sink_def = "alsa_output.pci-0000_00_1f.3.analog-stereo"

local M = {
	enable = function() end,
	disable = function() end,
}

local function normalize(s)
	return s:gsub("\r\n", "\n"):gsub("^%s+", ""):gsub("%s+$", "")
end

local function set_functions(data)
	function M.enable()
		awful.spawn(string.format("pactl set-sink-port %s %s", default_sink, data.ports.headphones))
	end

	function M.disable()
		awful.spawn(string.format("pactl set-sink-port %s %s", default_sink, data.ports.speakers))
	end
end

local function parse_data(data)
	local result = {}
	for _, sink in ipairs(data) do
		helpers.debug_log(string.format("string1len = %d \n string2len = %d", #sink.name, #default_sink))
		helpers.debug_log(string.format("%q", normalize(sink.name)))
		helpers.debug_log(string.format("%q", default_sink_def))
		if normalize(sink.name) == default_sink_def then
			result.sink = sink.name
			result.id = sink.index
			result.ports = {}
			for _, port in ipairs(sink.ports) do
				if port.type == "Line" or port.type == "Speaker" then
					result.ports.speakers = port.name
				elseif port.type == "Headphones" then
					result.ports.headphones = port.name
				end
			end
		end
	end
	return result
end

local function fetch_data()
	awful.spawn.easy_async(paclt_list_cmd, function(stdout, stderr, reason, exitcode)
		if stdout then
			local decoded_data = json.decode(stdout)
			local data = parse_data(decoded_data)
			set_functions(data)
		end
	end)
end

function M.init()
	local get_default_sink_cmd = [[pactl get-default-sink]]
	awful.spawn.easy_async(get_default_sink_cmd, function(stdout, stderr, _, exitcode)
		if exitcode == 0 then
			default_sink = stdout
			fetch_data()
		else
			helpers.debug_log(string.format("Error getting default sink: %s", stderr))
		end
	end)
end

return M
