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

---comment
---@param raw string
---@return table
local function get_ip(raw)
	local ips = {}
	for line in raw:gmatch("%d+%.%d+%.%d+%.%d+") do
		table.insert(ips, line)
	end
	if #ips == 2 then
		return { inet = ips[1], public = ips[2] }
	elseif #ips == 1 then
		return { inet = ips[1] }
	else
		helpers.debug_log("couldn't find any ip from the command")
		error("Error running script")
		return {}
	end
end

awesome.connect_signal("internet::connected", function()
	naughty.notification({ title = "Connection status", message = "Successfully connected to the interne." })
	internet_connection_widget.markup = helpers.colorize_text(icons.active, beautiful.accent)
end)

awesome.connect_signal("internet::disconnected", function()
	naughty.notification({ title = "Connection status", message = "Internet connection lost" })
	internet_connection_widget.markup = helpers.colorize_text(icons.active, beautiful.accent)
end)

-- TOOLTIP
--
local nw_tooltip = awful.tooltip({
	text = "Network info ...",
	visibile = true,
	bg = beautiful.bg_normal,
})

nw_tooltip:add_to_object(internet_connection_widget)

internet_connection_widget:connect_signal("mouse::enter", function()
	awful.spawn.easy_async(network_status_script, function(stdout, stderr, reason, exit_code)
		local ips = get_ip(stdout)
		local output = ""
		if ips.inet ~= nil then
			output = output .. "\nINET: " .. ips.inet
		end
		if ips.public ~= nil then
			output = output .. "\nPublic: " .. ips.public
		end
		nw_tooltip.markup = "<b>NETWORK INFO:</b>" .. output
	end)
end)
local function test_menu()
	helpers.debug_log("Click callback works")
end

local option_menu = awful.menu({
	items = {
		{ "Turn off card", test_menu },
		{
			"second button",
			function()
				helpers.debug_log("In line function on second button")
			end,
		},
	},
	theme = {
		height = 15,
		width = 150,
		bg_focus = beautiful.bg_hover,
		fg_focus = beautiful.accent,
	},
})

internet_connection_widget:buttons(awful.button({}, 1, function()
	option_menu:toggle()
end))

return internet_connection_widget
