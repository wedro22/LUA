local time_sleep = 120
local path = fs.getDir(fs.getDir(shell.getRunningProgram()))
package.path = package.path..';/'..path..'/Tools/?.lua'

local near = require("Nearby")
local container_utils = require("ContainerUtils")
local file_utils = require("FileUtils")
local item = require("Item")
local periphery = require("Periphery")

--filter list, structure as {left = {items}, right = {items}, ..}
local filter
local nearby

local function reloadFilter()
    filter = {}
    local state, tabl = file_utils.readJSON("FilterList.lua")
    if state then filter = tabl; end
end

--only container-type nearby periphery
local function reloadNearby()
    nearby = {}
    local tabl = near.getTypes()
    for side, typ in pairs(tabl) do
        if typ then
            local p = periphery:new(side)
            if p then
                if p:hasMethod("list") then
                    table.insert(nearby, v)
                end
            end
        end
    end
end

local function pushFilterItems()
    from = filter["From"]
    if not from then return; end
    periphery_from = periphery:new(from)
    if not periphery_from then return; end
    state, list_from = periphery_from:getList()
    if not state then return; end
    if #list_from == 0 then return; end
    for slot, itm in pairs(list_from) do
        _itm = item:new(itm)
        if not _itm then break; end
        for _, side in pairs(filter) do
            if side == "From" then break; end
            for _, filter_itm in pairs(filter[side]) do
                if _itm:compare(filter_itm) then
                    periphery_to = periphery:new(side)
                    if not periphery_to then break; end
                    container_utils.takeFromTo(periphery_from, slot, periphery_to)
                end
            end
        end
    end
end






while true do
    reloadFilter()
    reloadNearby()
    while (#filter==0) or (#nearby==0) do
        sleep(time_sleep)
        reloadFilter()
        reloadNearby()
    end

    pushFilterItems()

    sleep(time_sleep)
end
