local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("modules.utils.helpers")

local network_status_script = "/home/wose/.dotfiles/awesome/dot-config/awesome/modules/network/get_network_status.sh"
local icons = {
	active = "󰞉",
}

local internet_connection_widget = wibox.widget({
	widget = wibox.widget.textbox,
	markup = icons.active,
	haling = "center",
	valign = "middle",
	font = beautiful.icon .. " 12",
})

awesome.connect_signal("internet::connected", function()
	naughty.notification({ title = "Connection status", message = "Successfully connected to the interne." })
	internet_connection_widget.markup = helpers.colorize_text(icons.active, beautiful.accent)
end)

awesome.connect_signal("internet::disconnected", function()
	internet_connection_widget.markup = helpers.colorize_text(icons.active, beautiful.accent)
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
		nw_tooltip.text = "Newtwork info \n" .. stdout
	end)
end

internet_connection_widget:connect_signal("mouse::enter", nw_status)

nw_tooltip:add_to_object(internet_connection_widget)

return internet_connection_widget
