local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local network_check_bash_script =
	"/home/wose/.dotfiles/awesome/dot-config/awesome/modules/network/check-internet-connection.sh"

local internet_connection_widget = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "",
	aling = "center",
	valign = "middle",
	font = "JetBrainMono Nerd Font Mono 12",
	forced_width = 13,
})

local function check_network_status()
	awful.spawn.easy_async_with_shell(network_check_bash_script, function(stdout)
		local status = tonumber(stdout)

		if status == 0 then
			internet_connection_widget.markup = "<span color='" .. beautiful.bg_focus .. "'>󰞉</span>"
		else
			internet_connection_widget.markup = "<span color='" .. beautiful.bg_minimize .. "'>󱞐</span>"
		end
	end)
end

gears.timer({
	timeout = 5,
	call_now = true,
	autostart = true,
	callback = function()
		check_network_status()
	end,
})

return internet_connection_widget
