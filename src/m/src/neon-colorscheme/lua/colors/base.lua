local M = {}

---@return Palette
function M.get()
	---@class Palette
	---@field black string
	---@field bright_black string
	---@field black_blue string
	---@field grey string
	---@field white string
	---@field white_blue string
	---@field green string
	---@field teal string
	---@field dark_teal string
	---@field blue string
	---@field dark_blue string
	---@field purple string
	---@field violet string
	---@field magenta string
	---@field pink string
	---@field peach string
	---@field yellow string
	colors = {
		black = "#090a13",
		bright_black = "#0f101c",
		black_blue = "#191826",
		grey = "#8d8fa7",
		white = "#b7bad9",
		white_blue = "#9afff9",
		green = "#00dc79",
		teal = "#00d8b6",
		dark_teal = "#00afb7",
		blue = "#00a3f3",
		dark_blue = "#6f9bff",
		purple = "#a38dff",
		violet = "#c280ff",
		magenta = "#df68ff",
		pink = "#ff61c8",
		peach = "#ff668e",
		yellow = "#ddd66e",
	}
	colors.ui = {
		bg_popup = colors.black_blue,
		fg = colors.white_blue,
		fg_hi = colors.white,
		bg = colors.black,
		bg_visual = colors.pink,
		border = colors.grey,
		border_hi = colors.violet,
		none = "NONE",
	}
	colors.diagnostic = {
		hint = colors.blue,
		info = colors.purple,
		warn = colors.yellow,
		error = colors.peach,
		success = colors.green,
	}
	return colors
end

return M
