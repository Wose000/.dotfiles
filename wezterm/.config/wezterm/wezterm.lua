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
		"#25283d",
		"#9566ce",
		"#40ae6e",
		"#c8d362",
		"#216bd2",
		"#605cd0",
		"#e098df",
		"#06b09c",
	},
	brights = {
		"#2d315d",
		"#cb9cf9",
		"#7acb7a",
		"#f6927b",
		"#75baff",
		"#b1a8f9",
		"#3fc7e7",
		"#41cdb8",
	},
}

return config
