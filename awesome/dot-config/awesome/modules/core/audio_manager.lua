local awful = require("awful")

local helpers = require("modules.utils.helpers")

local M = {}

local subjects = {
	sink_change = "on server",
	volume_change = "on sink",
	profile_change = "on card",
}

local kill_cmd = [[pkill -f "pactl subscribe"]]
local cmd = [[pactl subscribe]]
local get_volume_cmd = [[wpctl get-volume @DEFAULT_SINK@]]

local function handle_volume_change()
	awful.spawn.easy_async(get_volume_cmd, function(stdout, _, _, _, _)
		local _, _, volume = string.find(stdout, "Volume: (%d*.%d*)")
		awesome.emit_signal("audio_manager::volume_change", { value = tonumber(volume) })
	end)
end

local function parse_event(event)
	local _, _, event_type, subject, index = string.find(event, "Event '(%a*)' (.*) #(%d*)")
	if event_type == "change" then
		if subject == subjects.volume_change then
			handle_volume_change()
		elseif subject == subjects.sink_change then
			helpers.debug_log(string.format("sink changed: index %d", tonumber(index)))
		elseif subject == subjects.profile_change then
			helpers.debug_log(string.format("profile changed: index %d", tonumber(index)))
		end
	end
end

local function test_sub()
	helpers.debug_log("called")
	local _ = awful.spawn.with_line_callback(cmd, {
		stdout = function(line)
			parse_event(line)
		end,
		stderr = function(stderr) end,
		output_done = function() end,
		exit = function(reason, code) end,
	})
end

awful.spawn.easy_async(kill_cmd, function(stdout, stderr, reason, exit_code)
	test_sub()
end)

return M
