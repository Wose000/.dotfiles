local rnotif = require("ruled.notification")
local helpers = require("modules.utils.helpers")
local beutiful = require("beautiful")

rnotif.connect_signal("request::rules", function()
	rnotif.append_rule({
		rule = { urgency = "normal" },
		properties = { bg = beutiful.bg_normal, fg = beutiful.fg_normal, border_color = beutiful.accent },
	})

	rnotif.append_rule({
		rule = { urgency = "critical" },
		properties = { bg = beutiful.bg_normal, fg = beutiful.fg_normal, border_color = beutiful.bg_urgent },
	})
end)
