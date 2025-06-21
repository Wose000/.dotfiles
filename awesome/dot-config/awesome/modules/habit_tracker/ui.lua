date = require("date")

today = os.date("%d %m %Y")

d = date(os.date())

assert(d:getday() == 21)
d:adddays(1)
assert(d:getday() == 22)

d:adddays(9)
print(d:getday())

date_with_bars = os.date("%Y-%m-%d")
assert(date_with_bars == "2025-06-21")
date_bars_removed = string.gsub(date_with_bars, "-", " ")
assert(date_bars_removed == "2025 06 21")
