local json = require("dkjson")
local naughty = require("naughty")

local M = {}

function M.colorize_text(text, color)
	return "<span color='" .. color .. "'>" .. text .. "</span>"
end

---decode a json file and return a table
---@param encoded_data string
---@return table|unknown
function M.decode_json(encoded_data)
	local data, _, err = json.decode(encoded_data)
	if err then
		naughty.notification({
			title = "Error reading JSON",
			message = "Error while trying to read a json file " .. type(data) .. "\nerror: " .. err,
		})
		error(err)
	end
	if type(data) == "table" then
		return data
	else
		naughty.notification({ title = "Error deconding JSON", message = "Expected a table found " .. type(data) })
		error("expected a table as json.decode output found " .. type(data))
	end
end

---encode a table as JSON string
---@param data table
---@return string
function M.encode_json(data)
	local data_as_json = json.encode(data, { indent = true })
	if type(data_as_json) == "string" then
		return data_as_json
	else
		naughty.notification({ title = "Error encoding JSON", message = "Expected a string found " .. type(data) })
		error("Error encoding data as json")
	end
end

function M.debug_log(msg)
	naughty.notification({ title = "DEBUG", message = msg, urgency = "normal" })
end

return M
