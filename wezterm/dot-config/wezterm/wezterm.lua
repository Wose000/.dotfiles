-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- tab bar disabled
config.enable_tab_bar = false

-- background
config.window_background_opacity = 0.85

config.warn_about_missing_glyphs = false

-- font
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10

-- colors
l = "#a48cf2"
config.colors = {
	foreground = "#abc3d7",
	background = "#101213",
	ansi = {
		"#161616", -- black
		"#f265b5", -- red
		"#a277d1", -- green
		"#b1a8f9", -- yellow
		"#8aa7ff", -- blue
		"#33fa99", -- magenta
		"#42a3e3", -- cyan
		"#00d1b1", -- white
	},
	brights = {
		"#8c9297", -- black
		"#f265b5", -- red
		"#b1a8f9", -- green
		"#7481d1", -- yellow
		"#a874ce", -- blue
		"#00d1b1", -- magenta
		"#27d877", -- cyan
		"#459Ade", -- white
	},
}

return config
