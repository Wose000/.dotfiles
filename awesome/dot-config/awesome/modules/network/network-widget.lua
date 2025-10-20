local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local network_status_script = "/home/wose/.dotfiles/awesome/dot-config/awesome/modules/network/get_network_status.sh"

local internet_connection_widget = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "",
	aling = "center",
	valign = "middle",
	font = "JetBrainMono Nerd Font Mono 12",
	forced_width = 13,
})

awesome.connect_signal("internet::connected", function()
	naughty.notification({ title = "Connection status", message = "Successfully connected to the interne." })
	internet_connection_widget.markup = "<span color='" .. beautiful.accent .. "'>󰞉</span>"
end)

awesome.connect_signal("internet::disconnected", function()
	internet_connection_widget.markup = "<span color='" .. beautiful.inactive .. "'>󱞐</span>"
	naughty.notification({ title = "Connection status", message = "Internet connection lost" })
end)

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
