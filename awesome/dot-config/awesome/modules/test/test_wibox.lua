local wibox = require("wibox")

local function log(msg)
	local file = io.open("/home/wose/.dotfiles/awesome/dot-config/awesome/modules/habit_tracker/data/log.txt", "a")
	if not file then
		return
	end
	local formatted_datetime = os.date("%Y-%m-%d %H:%M:%S")
	file:write(formatted_datetime .. ": " .. msg .. "\n")
	file:close()
end

local M = {}

local tb = wibox.widget.textbox()
tb:connect_signal("mouse::enter", function()
	tb.text = "mouse entered"
	tb:emit_signal("porco::dio")
end)
tb.text = "dio cane"

local layout = wibox.layout.fixed.vertical()
layout:connect_signal("porco::dio", function()
	log("layout listened to signal porco::dio")
	layout:emit_signal("porco::dio")
end)

local bg = wibox.container.background()
bg.bg = "#000000"
bg:connect_signal("porco::dio", function()
	bg.bg = "#f4f000"
end)

M.mywibox = wibox()

M.mywibox:setup({
	{
		{ text = "Hello World", widget = wibox.widget.textbox },
		{ widget = tb },
		layout = layout,
	},
	widget = bg,
})

M.mywibox.ontop = true
M.mywibox.width = 500
M.mywibox.height = 500
M.mywibox.x = 500
M.mywibox.y = 0

function M:toggle_wibox()
	M.mywibox.visible = not M.mywibox.visible
end

return M
