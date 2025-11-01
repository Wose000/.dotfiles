local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")

local audio_script = "~/bin/scripts/headphones.sh"

local audio_widget = wibox.widget.textbox()
audio_widget.font = "JetBrainsMono Nerd Font Mono 14"
audio_widget.valign = "center"

local function update_audio_icon()
	awful.spawn.easy_async_with_shell(audio_script, function(stdout)
		audio_widget.text = stdout:gsub("\n", "")
	end)
end

update_audio_icon()

audio_widget:buttons(gears.table.join(awful.button({}, 1, function()
	awful.spawn.easy_async_with_shell(audio_script .. " --toggle", function()
		update_audio_icon()
	end)
end)))

gears.timer({
	timeout = 5,
	autostart = true,
	callback = update_audio_icon,
})

return audio_widget
