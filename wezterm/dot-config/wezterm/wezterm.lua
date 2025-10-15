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
config.colors = {
	foreground = "#abc3d7",
	background = "#101213",

	ansi = {
		"#25283d", -- black
		"#f265b5", -- magenta
		"#b1a8f9", -- red
		"#a277d1", -- red
		"#8390e2", -- blue
		"#36b0c1", -- cyan
		"#459Ade", -- cyan
		"#00eba5", -- green
	},
	brights = {
		"#8c9297", -- black
		"#f265b5", -- magenta
		"#b1a8f9", -- red
		"#7481d1", -- blue
		"#a874ce", -- red
		"#36b0c1", -- cyan
		"#27d877", -- green
		"#459Ade", -- cyan
	},
}

return config
