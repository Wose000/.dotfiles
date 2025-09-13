local M = {}

function M.colorize_text(text, color)
	return "<span color='" .. color .. "'>" .. text .. "</span>"
end

return M
