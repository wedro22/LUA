local path = fs.getDir(fs.getDir(shell.getRunningProgram()))
package.path = package.path..';/'..path..'/Tools/?.lua'

local time_sleep = 120
local near = require("Nearby")
local container_utils = require("ContainerUtils")
local file_utils = require("FileUtils")
local itm = require("Item")
local periphery = require(Periphery)

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
            local p = periphery.new(side)
            if p:hasMethod("list") then
                table.insert(nearby, v)
            end
        end
    end
end






reloadFilter()
reloadNearby()