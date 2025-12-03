local helpers = require("modules.utils.helpers")
local redshift = require("modules.control_center.redshift")
local ControlButton = require("modules.control_center.control_button")
local icon = ""
---
---@class RedshiftButton : ControlButton
local RedshiftButton = setmetatable({}, ControlButton)
RedshiftButton.__index = RedshiftButton

---Create redshift button
---@return ControlButton|RedshiftButton
function RedshiftButton:new()
	local obj = ControlButton.new(self, icon)
	return setmetatable(obj, self)
end

---@param self RedshiftButton
function RedshiftButton:on_select_callback()
	helpers.debug_log("called on selected from implementing class")
	redshift.enable()
end

---@param self RedshiftButton
function RedshiftButton:on_release_callback()
	helpers.debug_log("called on release from implementing class")
	redshift.disable()
end

return RedshiftButton
