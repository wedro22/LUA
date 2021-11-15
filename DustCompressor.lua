--storagedrawers:controller_0 --turtle_0
local storagedrawers = "storagedrawers:controller"  --хранилка пылей
local turtle = "turtle"  --туртл€ дл€ сбора кучек
local device_all = {}  --список всех устройств сети, обновл€етс€ refrechDevices()

--инициализаци€ модема
local modem = peripheral.find("modem")
modem.open(15)

--обновление списка устройств device_all
local function refrechDevices()
	device_all = modem.getNamesRemote()
end

--[[возвращает список устройств в данной сети по аргументу-преффиксу имени.
ѕри переключении устройств, могут мен€тьс€ их суффиксы (номера),
поэтому работать даже с 1 устройством, как со списком, надежнее --]]
local function getDeviceList(device_name)
	local dev_list = {}
	for _, dev in pairs(device_all) do
		if string.sub(device_name, 1, #device_name) == device_name then
			table.insert(dev_list, dev)
		end
	end
	return dev_list
end

refrechDevices()
print(getDeviceList(storagedrawers))