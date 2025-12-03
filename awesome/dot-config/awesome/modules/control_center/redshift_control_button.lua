local helpers = require("modules.utils.helpers")
local redshift = require("modules.control_center.redshift")
local ControlButton = require("modules.control_center.control_button")
local icon = ""

local RedshiftButton = setmetatable({}, ControlButton)
RedshiftButton.__index = RedshiftButton

function RedshiftButton:new()
	local obj = ControlButton:new(icon)
	return obj
end

function RedshiftButton:on_select_callback()
	helpers.debug_log("called calback")
	redshift.enable()
end
function RedshiftButton:on_release_callback()
	redshift.disable()
end

return RedshiftButton
