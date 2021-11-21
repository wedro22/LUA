local all_period = 60
local device_all = {}  --список всех устройств сети, обновляется refrechDevices()
local storagename = "storagedrawers:controller"  --хранилка пылей
local storage  --таблица хранилка пылей
local turtl
--сундуки для подключений
local chest_all = {}  --список всех сундуков сети, обновляется refrechDevices()
local chest_names = {
	gregchest = "gregtech:machine",
	ironchest = "minecraft:ironchest",
	chest = "minecraft:chest",
	largishchest = "xu2:tilelargishchest"
}
--стандартный шаблон грегтех итемов от информации getItemDetail = пыль? меньше чем damage и соотв. имя
local gID = {dustTiny_min_damage = 0, dustTiny_max_damage = 999, name = "gregtech:meta_item_1",
			 dust_min_damage = 2000, dust_max_damage = 2999,
			 dustSmall_min_damage = 1000, dustSmall_max_damage = 1999}

--список итемов, собираемых из сундуков
local minecraft = {}
local path = fs.getDir(shell.getRunningProgram())
local file = path.."/Itemlist.lua"
--local minecraft = {"minecraft:iron_nugget", "minecraft:gold_nugget", "minecraft:redstone"}
if fs.exists(file) then
	f = fs.open(file, "r")
	str = f.readLine()
	while str do
		if #str > 5 then  --вставлять в таблицу только более длинные строки
			--str = string.sub(str, 2, #str-1) --если есть ковычки
			table.insert(str)
		end
		str = f.readLine()
	end
	f.close()
end



--инициализация модема
local modem = peripheral.find("modem")
modem.open(15)

--обновление списка устройств device_all
local function refrechDevices()
	device_all = modem.getNamesRemote()
	turtl = modem.getNameLocal()
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

local function unloadAll()
	for i=1, 16 do
		if turtle.getItemCount(i)>0 then
			--pullItems(fromName, fromSlot [, limit [, toSlot]])
			modem.callRemote(storage[1], "pullItems", turtl, i, 64, 1)
			sleep(1)
			if turtle.getItemCount(i)>0 then
				while turtle.getItemCount(i)>0 do
					sleep(all_period)
					modem.callRemote(storage[1], "pullItems", turtl, i, 64, 1)
					sleep(1)
					if turtle.getItemCount(i)>0 then
						turtle.drop(64)
					end
				end
			end
		end
	end
end

--для крафта 3х3
local function getTurtleSlot(index)
	slot = index
	if index>=4 and index<=6 then
		slot = index+1
	elseif index>6 then
		slot = index+2
	end
	return slot
end
--для крафта 2х2
local function getTurtleSlotSmall(index)
	slot = index
	if index>2 then
		slot = index+2
	end
	return slot
end

local function turtle_get(chest, fromSlot, lim, toSlot)
	modem.callRemote(chest, "pushItems", turtl, fromSlot, lim, toSlot)
	sleep(0.2)
end

local function chest_stack(chest)
	lut = modem.callRemote(chest, "list")
	if (not lut) or #lut == 0 then
		return
	end
	--составление таблицы всех tiny пылей сортируя по параметру damage типа
	--таблицаПыли{пыль1(в качестве имени - damage)={номер слота=кол-во, номер слота=кол-во}, пыль2={}}
	dustsTiny = {}  --таблица всех tiny пылей
	dustsTinySumm = {}  --некрасиво, для порядка первой таблицы, подсчет сумм пылей идёт в отдельной типа имя = сумма
	dustsSmall = {}
	dustsSmallSumm = {}
	
	dusts = {}  --простые пыли. хранит ТОЛЬКО номера слотов, простой массив
	items = {}  --другие итемы напр. минекрафт наггеты
	
	for i, item in pairs(lut) do
		--gregtech "gregtech:meta_item_1"
		if item.name == gID.name then
		
			--если dustTiny
			
			if (item.damage >= gID.dustTiny_min_damage) and (item.damage <= gID.dustTiny_max_damage) then
				--если поля пыли еще нет
				if not dustsTiny[item.damage] then
					dustsTiny[item.damage] = {}
					dustsTinySumm[item.damage] = 0
				end
				dustsTiny[item.damage][i] = item.count
				dustsTinySumm[item.damage] = dustsTinySumm[item.damage] + item.count
				
			--если dust
			
			elseif (item.damage >= gID.dust_min_damage) and (item.damage <= gID.dust_max_damage) then
				table.insert(dusts, i)
				
			--если smallDust
			
			elseif (item.damage >= gID.dustSmall_min_damage) and (item.damage <= gID.dustSmall_max_damage) then
				--если поля пыли еще нет
				if not dustsSmall[item.damage] then
					dustsSmall[item.damage] = {}
					dustsSmallSumm[item.damage] = 0
				end
				dustsSmall[item.damage][i] = item.count
				dustsSmallSumm[item.damage] = dustsSmallSumm[item.damage] + item.count
				
			--если 
			end
			
		--minecraft
		else
			for _, str in pairs(minecraft) do
				if item.name == str then
					table.insert(items, i)
				end
			end
		end
	end
	
	-- работа с tiny dust
	for dust, count in pairs(dustsTinySumm) do
		--math.floor(count/9)
		if count>=9 then
			maxcount = count
			if maxcount > 576 then
				maxcount = 576
			end
			
			n9 = math.floor(maxcount/9)
			
			
			index = 1
			
			for cell, cellcount in pairs(dustsTiny[dust]) do
				lim = n9-turtle.getItemCount(getTurtleSlot(index))
				if lim>0 then
					turtle_get(chest, cell, lim, getTurtleSlot(index))
				end
				while ((turtle.getItemCount(getTurtleSlot(index))>=n9) and (index<9)) do
					index = index + 1
					lim = n9-turtle.getItemCount(getTurtleSlot(index))
					if lim>0 then
						turtle_get(chest, cell, lim, getTurtleSlot(index))
					end
				end
			end
			
			turtle.select(16)
			turtle.craft(64)
			unloadAll()
		end
	end
	
	--работа с dust простыми
	for _, cell in pairs(dusts) do
		turtle_get(chest, cell, 64, 16)
		unloadAll()
	end
	
	--работа с Small dust
	for dust, count in pairs(dustsSmallSumm) do
		--math.floor(count/4)
		if count>=4 then
			maxcount = count
			if maxcount > 256 then
				maxcount = 256
			end
			
			n4 = math.floor(maxcount/4)
			
			
			index = 1
			
			for cell, cellcount in pairs(dustsSmall[dust]) do
				lim = n4-turtle.getItemCount(getTurtleSlotSmall(index))
				if lim>0 then
					turtle_get(chest, cell, lim, getTurtleSlotSmall(index))
				end
				while ((turtle.getItemCount(getTurtleSlotSmall(index))>=n4) and (index<4)) do
					index = index + 1
					lim = n4-turtle.getItemCount(getTurtleSlotSmall(index))
					if lim>0 then
						turtle_get(chest, cell, lim, getTurtleSlotSmall(index))
					end
				end
			end
			
			turtle.select(16)
			turtle.craft(64)
			unloadAll()
		end
	end
	
	--работа с items простыми
	for _, cell in pairs(items) do
		turtle_get(chest, cell, 64, 16)
		unloadAll()
	end
end


refrechDevices()
sleep(1)
storage = getDeviceList(storagename)
unloadAll()
while true do
	for i, chest in pairs(chest_all) do
		print(i, "/", #chest_all, chest)
		chest_stack(chest)
		sleep(all_period/#chest_all)
	end
end





