-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- tab bar disabled
config.enable_tab_bar = false

-- background
config.window_background_opacity = 0.95

-- font
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10

-- colors
config.colors = {
	foreground = "#aedbf0",
	background = "#101010",

	ansi = {
		"#25283d",
		"#ab7dd7",
		"#5bab5c",
		"#c88939",
		"#4a9ae6",
		"#9289d7",
		"#00a9c9",
		"#06b09c",
	},
	brights = {
		"#2d315d",
		"#cb9cf9",
		"#7acb7a",
		"#e6a557",
		"#75baff",
		"#b1a8f9",
		"#3fc7e7",
		"#41cdb8",
	},
}

return config
