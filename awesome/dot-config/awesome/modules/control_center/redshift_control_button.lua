local redshift = require("modules.control_center.redshift")
local ControlButton = require("modules.control_center.control_button"):new("")

local RedshiftButton = setmetatable({}, ControlButton)
RedshiftButton.__index = RedshiftButton

function RedshiftButton:new() end

function RedshiftButton:on_select_callback()
	redshift.enable()
end
function RedshiftButton:on_release_callback()
	redshift.disable()
end

return RedshiftButton
