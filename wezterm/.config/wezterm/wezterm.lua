-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- tab bar disabled
config.enable_tab_bar = false

-- background
config.window_background_opacity = 0.75

-- font
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10

-- colors
config.colors = {
	foreground = "#aedbf0",
	background = "#101010",

	ansi = {
		"#25283d",
		"#6f42e0",
		"#1fff75",
		"#f5ff9b",
		"#36abff",
		"#e358ff",
		"#02daac",
		"#23eae0",
	},
	brights = {
		"#2d315d",
		"#b058f7",
		"#3ff57f",
		"#f8fba3",
		"#55b0f6",
		"#e766f8",
		"#25f4c0",
		"#3fe7dc",
	},
}

return config
