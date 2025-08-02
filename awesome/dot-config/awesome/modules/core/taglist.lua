local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local M = {}

M.taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

function M.get_taglist_widget(s)
	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = {
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						id = "index_role",
						font = "JetBrainMono Nerd Font Mono 14",
						widget = wibox.widget.textbox,
						forced_width = 20,
					},
					left = 5,
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			id = "background_role",
			widget = wibox.container.background,
			-- Add support for hover colors and an index label
			create_callback = function(self, c3, index, objects) --luacheck: no unused args
				if c3.selected then
					self:get_children_by_id("index_role")[1].markup = ""
				elseif #c3:clients() == 0 then
					self:get_children_by_id("index_role")[1].markup = ""
				else
					self:get_children_by_id("index_role")[1].markup = ""
				end
				self:connect_signal("mouse::enter", function()
					if self.bg ~= beautiful.bg_normal then
						self.backup = self.bg
						self.has_backup = true
					end
					self.bg = beautiful.bg_normal
				end)
				self:connect_signal("mouse::leave", function()
					if self.has_backup then
						self.bg = self.backup
					end
				end)
			end,
			update_callback = function(self, c3, index, objects) --luacheck: no unused args
				if c3.selected then
					self:get_children_by_id("index_role")[1].markup = "<span color='"
						.. beautiful.bg_urgent
						.. "'>"
						.. ""
						.. "</span>"
				elseif #c3:clients() == 0 then
					self:get_children_by_id("index_role")[1].markup = ""
				else
					self:get_children_by_id("index_role")[1].markup = ""
				end
			end,
		},
		buttons = M.taglist_buttons,
	})
end

return M
