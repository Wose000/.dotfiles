local Gio = require("lgi").Gio
local naughty = require("naughty")

local BLUEZ_SERVICE = "org.bluez"
local ADAPTER_PATH = "/org/bluez/hci0"
local ADAPTER_INTERFACE = "org.bluez.Adapter1"

local function create_bluetooth_proxy()
	local proxy, err = Gio.DbusProxy.new_sync(
		Gio.BusType.SYSTYEM,
		Gio.DBusProxyFlag.NONE,
		BLUEZ_SERVICE,
		ADAPTER_PATH,
		ADAPTER_INTERFACE,
		nil
	)
	if not proxy then
		naughty.notification({
			title = "Not proxy",
			message = string.format("Could not create proxy because: %s", err),
		})
	else
		return proxy
	end
end
