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
		"#a874ce", -- red
		"#44b2c1", -- green
		"#ce73ce", -- yellow
		"#7481d1", -- blue
		"#f265b5", -- magenta
		"#5fe3c2", -- cyan
		"#03b6b0", -- white
	},
	brights = {
		"#8c9297", -- black
		"#b1a8f9", -- red
		"#71d075", -- green
		"#3fc7e7", -- yellow
		"#44b2c1", -- blue
		"#f265b5", -- magenta
		"#5fe3c2", -- cyan
		"#03b6b0", -- white
	},
}

return config
