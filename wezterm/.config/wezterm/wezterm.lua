-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- tab bar disabled
config.enable_tab_bar = false

-- background
config.window_background_opacity = 0.85

-- font
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10

-- colors
config.colors = {
	foreground = "#aedbf0",
	background = "#101010",

	ansi = {
		"#25283d", -- black
		"#a874ce", -- red
		"#08ce81", -- green
		"#fb9893", -- yellow
		"#8a7ede", -- blue
		"#f265b5", -- magenta
		"#1d9ec1", -- cyan
		"#03b6b0", -- white
	},
	brights = {
		"#25283d", -- black
		"#a874ce", -- red
		"#6ae458", -- green
		"#fb9893", -- yellow
		"#8a7ede", -- blue
		"#f265b5", -- magenta
		"#1d9ec1", -- cyan
		"#03b6b0", -- white
	},
}

return config
