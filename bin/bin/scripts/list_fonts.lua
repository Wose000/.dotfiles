#!/usr/bin/env lua

local lgi = require("lgi")
local pangocairo = lgi.PangoCairo

local font_map = pangocairo.font_map_get_default()

for k, v in pairs(font_map:list_families()) do
	print(v:get_name(), "monospace?: " .. tostring(v:is_monospace()))
	for k2, v2 in ipairs(v:list_faces()) do
		print("    " .. v2:get_face_name())
	end
end
