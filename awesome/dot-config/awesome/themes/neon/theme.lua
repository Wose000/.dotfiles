---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local themes_path = os.getenv("HOME") .. "/.config/awesome/themes/"
local wall_folder = themes_path .. "neon/wallp/"
local gears = require("gears")

local theme = {}

theme.font = "JetBrainsMono Nerd Font Mono 10"

theme.bg_normal = "#202a2d"
theme.bg_focus = "#03b6b0"
theme.bg_urgent = "#f265b5"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_normal

theme.fg_normal = "#abc3d7"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(3)
theme.border_width = dpi(2)
theme.border_normal = "#000000"
theme.border_focus = "#03b6b0"
theme.border_marked = "#f265b5"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_bg_occupied = theme.bg_minimize
theme.taglist_shape = gears.shape.rectangle
theme.taglist_shape_border_width = 4
theme.taglist_shape_border_color = theme.bg_normal

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = "JetBrainsMono Nerd Font Mono 10"
theme.notification_max_width = 400
theme.notification_icon_size = 60

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "neon/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "neon/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "neon/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "neon/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "neon/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "neon/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "neon/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "neon/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "neon/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "neon/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "neon/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "neon/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "neon/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "neon/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "neon/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "neon/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "neon/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "neon/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "neon/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "neon/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "neon/titlebar/maximized_focus_active.png"

local function list_files(dir)
	local files = {}
	local p = io.popen('ls "' .. dir .. '"')
	if p then
		for file in p:lines() do
			table.insert(files, file)
		end
		p:close()
	end
	return files
end

local function select_random_wall()
	local files = list_files(wall_folder)
	if #files == 0 then
		return wall_folder .. "d20.jpg"
	else
		return wall_folder .. files[math.random(#files)]
	end
end

math.randomseed(os.time())
local selected_wall = select_random_wall()

theme.wallpaper = selected_wall

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "neon/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "neon/layouts/fairvw.png"
theme.layout_floating = themes_path .. "neon/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "neon/layouts/magnifierw.png"
theme.layout_max = themes_path .. "neon/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "neon/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "neon/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "neon/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "neon/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "neon/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "neon/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "neon/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "neon/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "neon/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "neon/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "neon/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
