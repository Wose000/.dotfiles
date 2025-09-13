local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local habit_tracker = require("modules.habit_tracker.habit_tracker")
local mykeyboardlayout = awful.widget.keyboardlayout()
local mytextclock = wibox.widget.textclock()
mytextclock.format = "%a %d %b, %H:%M "
local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach(mytextclock, "tr")
local volume_widget = require("awesome-wm-widgets.pactl-widget.volume")({
	widget_type = "icon",
	with_icon = true,
	tooltip = true,
})
local network_widget = require("modules.network.network-widget")
local notify_widget = require("modules.notification-widget")
local taglist = require("modules.core.taglist")

local mysystray = wibox.widget.systray()
mysystray.base_size = 13
local centered_systray = wibox.container.margin(mysystray, 0, 0, 6, 6)
centered_systray.spacing = 3
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local audio_widget = require("modules.audio_toggle")
local task = require("modules.todo.task")

local function get_right_widgets(headphones, keyboard, tray, data, battery)
	if Is_desktop then
		return {
			layout = wibox.layout.fixed.horizontal,
			spacing = 10,
			tray,
			notify_widget:get_bar_icon(),
			habit_tracker.bar_icon,
			network_widget,
			headphones,
			data,
		}
	end
	return {
		layout = wibox.layout.fixed.horizontal,
		spacing = 5,
		tray,
		require("modules.control_center.control_center"):get_bar_icon(),
		notify_widget:get_bar_icon(),
		headphones,
		habit_tracker.bar_icon,
		network_widget,
		keyboard,
		battery(),
		data,
	}
end

awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	s.mytaglist = taglist.get_taglist_widget(s)

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s })

	if s == screen.primary then
		-- Add widgets to the wibox
		s.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
				s.mypromptbox,
			},
			{ layout = wibox.layout.fixed.horizontal, volume_widget },
			get_right_widgets(audio_widget, mykeyboardlayout, centered_systray, mytextclock, battery_widget),
		})
	else
		s.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				s.mytaglist,
				s.mypromptbox,
			},
			nil, -- Center widgets
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				spacing = 5,
				mytextclock,
			},
		})
	end
end)
