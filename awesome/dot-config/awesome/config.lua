local host = os.getenv("HOSTNAME")

Config = {
	audio = {
		---@type string port | profile
		output_switch = "",
	},
	network = {
		wired = false,
		wireless = false,
	},
	devices = {
		bluetooth = false,
	},
}

if host == "arch-pc" then
	Config.audio.output_switch = "port"
	Config.devices.bluetooth = false
	Config.network.wireless = false
	Config.network.wired = true
elseif host == "arch-laptop" then
	Config.audio.output_switch = "profile"
	Config.devices.bluetooth = false
	Config.network.wireless = false
	Config.network.wired = true
elseif host == "archlinux" then
	Config.audio.output_switch = "port"
	Config.devices.bluetooth = true
	Config.network.wireless = true
	Config.network.wired = true
end
