Nearby = {}


---getTypes Defines the periphery around itself
---@return table as {side = type}
function Nearby.getTypes()
    list = {}
        list.left = peripheral.getType("left")
        list.right = peripheral.getType("right")
        list.top = peripheral.getType("top")
        list.bottom = peripheral.getType("bottom")
        list.front = peripheral.getType("front")
        list.back = peripheral.getType("back")
    sleep(0.5)
    return list
end

---getSimilarFromTable Compares peripherals to a list
---@param list table list from which to choose
---@param name string what to look for by prefix
---@param name table what to look for by prefix
---@return table as {side = type}
function Nearby.getSimilarFromTable(list, name)
    local names = {}
    if type(name) == "string" then
        for side, n in pairs(list) do
            if string.sub(n, 1, #name) == name then
                names[side] = n
            end
        end
    elseif type(name) == "table" then
        for side, n in pairs(list) do
            for _, t in pairs(name) do
                if string.sub(n, 1, #t) == t then
                    names[side] = n
                end
            end
        end
    end
    return names
end



return Nearby