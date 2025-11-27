local redshift = require("modules.control_center.redshift")
local ControlButton = require("modules.control_center.control_button")

local control_button = ControlButton.new("󰈈", redshift.enable, redshift.disable)

local button = control_button:get_button()

return button
