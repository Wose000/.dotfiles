local json = require("dkjson")

local file = io.open("./data/habits.json", "r")

local habits_table = {}
if file then
	habits_table = file:read("*a")
	file:close()
end

local data, pos, err = json.decode(habits_table)

if err then
	print("Error", err)
else
	print(data[1].title)
end
