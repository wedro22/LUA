--storagedrawers:controller_0 turtle_0 minecraft:ironchest_diamond_0
--minecraft:chest_0 xu2:tilelargishchest_0
local device_all = {}  --список всех устройств сети, обновл€етс€ refrechDevices()
local storagedrawers = "storagedrawers:controller"  --хранилка пылей
--сундуки дл€ подключений
local chest_all = {}  --список всех сундуков сети, обновл€етс€ refrechDevices()
local chest_names = {
	ironchest = "minecraft:ironchest",
	chest = "minecraft:chest",
	largishchest = "xu2:tilelargishchest"
}



--инициализаци€ модема
local modem = peripheral.find("modem")
modem.open(15)

--обновление списка устройств device_all
local function refrechDevices()
	device_all = modem.getNamesRemote()
	--table.insert(device_all, 0, modem.getNameLocal()) --вставить себ€ на индекс 0
	for _, dev in pairs(device_all) do
		for _, ch in pairs(chest_names) do
			if string.sub(dev, 1, #ch) == ch then
				table.insert(chest_all, dev)
			end
		end
	end
end

--[[возвращает список устройств в данной сети по аргументу-преффиксу имени.
ѕри переключении устройств, могут мен€тьс€ их суффиксы (номера),
поэтому работать даже с 1 устройством, как со списком, надежнее --]]
local function getDeviceList(device_name)
	if (not device_name) or (#device_name == 0) then
		return nil
	end
	local dev_list = {}
	for _, dev in pairs(device_all) do
		if string.sub(dev, 1, #device_name) == device_name then
			table.insert(dev_list, dev)
		end
	end
	return dev_list
end

--своЄ им€ в сети
local function getSelf()
	return modem.getNameLocal()
end

refrechDevices()
for k, v in pairs(chest_all) do
	print(k, v)
end
