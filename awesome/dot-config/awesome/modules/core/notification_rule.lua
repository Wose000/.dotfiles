local rnotif = require("ruled.notification")
local helpers = require("modules.utils.helpers")

rnotif.connect_signal("request::rules", function()
	rnotif.append_rule({
		rule = { urgency = "normal" },
		properties = { bg = "#ffffff" },
	})
end)
