local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local network_check_bash_script =
	"/home/wose/.dotfiles/awesome/dot-config/awesome/modules/network/check-internet-connection.sh"
local network_status_script = "/home/wose/.dotfiles/awesome/dot-config/awesome/modules/network/get_network_status.sh"

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

local text = "network info.."

local nw_tooltip = awful.tooltip({
	text = text,
	visibile = true,
	bg = beautiful.bg_minimize,
})

local function nw_status()
	awful.spawn.easy_async(network_status_script, function(stdout, stderr, reason, exit_code)
		nw_tooltip.text = stdout
	end)
end

internet_connection_widget:connect_signal("mouse::enter", nw_status)

nw_tooltip:add_to_object(internet_connection_widget)

gears.timer({
	timeout = 5,
	call_now = true,
	autostart = true,
	callback = function()
		check_network_status()
	end,
})

return internet_connection_widget
