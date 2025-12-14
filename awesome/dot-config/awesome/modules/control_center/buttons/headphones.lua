local ControlButton = require("modules.control_center.control_button")
local headphones = require("modules.control_center.headphones_toggle")
headphones.init()
local helpers = require("modules.utils.helpers")

local icon = "󰋋"

---@class HeadphonesButton : ControlButton
local HeadphonesButton = {}
HeadphonesButton.__index = HeadphonesButton
setmetatable(HeadphonesButton, { __index = ControlButton })

---Create Volume Button
---@return ControlButton|HeadphonesButton
function HeadphonesButton:new()
	local obj = ControlButton.new(self, icon)
	return setmetatable(obj, HeadphonesButton)
end

---@param self HeadphonesButton
function HeadphonesButton:on_release_callback()
	headphones.disable()
end

---@param self HeadphonesButton
function HeadphonesButton:on_select_callback()
	headphones.enable()
end

return HeadphonesButton
