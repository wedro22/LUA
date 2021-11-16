local all_period = 20
local device_all = {}  --список всех устройств сети, обновляется refrechDevices()
local storagedrawers = "storagedrawers:controller"  --хранилка пылей
--сундуки для подключений
local chest_all = {}  --список всех сундуков сети, обновляется refrechDevices()
local chest_names = {
	ironchest = "minecraft:ironchest",
	chest = "minecraft:chest",
	largishchest = "xu2:tilelargishchest"
}
--стандартный шаблон грегтех итемов от информации getItemDetail = пыль? меньше чем damage и соотв. имя
local gID = {damage = 1000, name = "gregtech:meta_item_1"}



--инициализация модема
local modem = peripheral.find("modem")
modem.open(15)

--обновление списка устройств device_all
local function refrechDevices()
	device_all = modem.getNamesRemote()
	--table.insert(device_all, 0, modem.getNameLocal()) --вставить себя на индекс 0
	for _, dev in pairs(device_all) do
		for _, ch in pairs(chest_names) do
			if string.sub(dev, 1, #ch) == ch then
				table.insert(chest_all, dev)
			end
		end
	end
end

--[[возвращает список устройств в данной сети по аргументу-преффиксу имени.
При переключении устройств, могут меняться их суффиксы (номера),
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

--своё имя в сети
local function getSelf()
	return modem.getNameLocal()
end


local function chest_stack(chest)
	lut = modem.callRemote(chest, "list")
	if (not lut) or #lut == 0 then
		return
	end
	--составление таблицы всех пылей сортируя по параметру damage типа
	--таблицаПыли{пыль1(в качестве имени - damage)={номер слота=кол-во, номер слота=кол-во}, пыль2={}}
	dusts = {}  --таблица всех этих пылей
	dustsSumm = {} --некрасиво, для порядка первой таблицы, подсчет сумм пылей идёт в отдельной типа имя = сумма
	for i, item in pairs(lut) do
		--gregtech "gregtech:meta_item_1"
		if item.name == gID.name then
			--если dustTiny
			if item.damage < gID.damage then
				--если поля пыли еще нет
				if not dusts[item.damage] then
					dusts[item.damage] = {}
					dustsSumm[item.damage] = 0
				end
				dusts[item.damage][i] = item.count
				dustsSumm[item.damage] = dustsSumm[item.damage] + item.count
			end
		end
	end
	
	for dust, count in pairs(dustsSumm) do
		n9 = math.floor(count/9)
		if n9>0 then
			n=0
			for cell, c in pairs(dust[d]) do
				print(cell, c)
			end
		end
	end
	
	
end

refrechDevices()

for i, chest in pairs(chest_all) do
	is = chest_stack(chest)
	print(i, "/", #chest_all, chest)
	sleep(all_period/#chest_all)
end





