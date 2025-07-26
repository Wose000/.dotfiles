local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local network_check_bash_script =
	"/home/wose/.dotfiles/awesome/dot-config/awesome/modules/network/check-internet-connection.sh"
local network_status_script = "/home/wose/.dotfiles/awesome/dot-config/awesome/modules/network/get_network_status.sh"

local internet_status = {
	AVAILABLE = 1,
	UNAVAILABLE = 2,
	UNCHECKED = 3,
}

local last_web_status = internet_status.UNCHECKED
local current_web_status = internet_status.UNCHECKED

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
			current_web_status = internet_status.AVAILABLE
			internet_connection_widget.markup = "<span color='" .. beautiful.accent .. "'>󰞉</span>"
		else
			current_web_status = internet_status.UNAVAILABLE
			internet_connection_widget.markup = "<span color='" .. beautiful.inactive .. "'>󱞐</span>"
		end
	end)

	if last_web_status == internet_status.UNCHECKED then
		last_web_status = current_web_status
		return
	end

	if current_web_status ~= last_web_status then
		if current_web_status == internet_status.AVAILABLE then
			naughty.notification({ title = "Connection status", message = "Successfully connected to the interne." })
		else
			naughty.notification({ title = "Connection status", message = "Internet connection lost" })
		end
	end

	last_web_status = current_web_status
end

gears.timer({
	timeout = 5,
	call_now = true,
	autostart = true,
	callback = function()
		check_network_status()
	end,
})

-- TOOLTIP
--
local nw_tooltip = awful.tooltip({
	text = "Network info ...",
	visibile = true,
	bg = beautiful.bg_normal,
})

local function nw_status()
	awful.spawn.easy_async(network_status_script, function(stdout, stderr, reason, exit_code)
		nw_tooltip.text = "Newtwork info: \n" .. stdout
	end)
end

internet_connection_widget:connect_signal("mouse::enter", nw_status)

nw_tooltip:add_to_object(internet_connection_widget)

return internet_connection_widget
