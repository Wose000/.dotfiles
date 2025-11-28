local json = require("dkjson")
local awful = require("awful")
local helpers = require("modules.utils.helpers")

local paclt_list_cmd = [[pactl -f json list sinks]]

local function parse_data(data)
	local result = {}
	for _, sink in ipairs(data) do
		if sink.state == "RUNNING" then
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

local function print_data(data)
	local output = string.format(
		"sink: %s, ports: %d, speaker:%s, headphones: %s",
		data.sink,
		#data.ports,
		data.ports.speakers,
		data.ports.headphones
	)
	helpers.debug_log(output)
	if data then
		for key, value in pairs(data) do
			helpers.debug_log(key .. " : " .. value)
		end
	end
end

local function fetch_data()
	awful.spawn.easy_async(paclt_list_cmd, function(stdout, stderr, reason, exitcode)
		if stdout then
			local decoded_data = json.decode(stdout)
			print_data(parse_data(decoded_data))
		end
	end)
end

fetch_data()
