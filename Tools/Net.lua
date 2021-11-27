Net = {}

---getNames List all remote peripherals on the wired network
---@return table names
function Net.getNamesRemote()
    names = {}
    --s, e = pcall(openModem)
    --if not pcall(openModem) then msg("modem error"); end
    s, e = pcall(function()
        modem = peripheral.find("modem"); sleep(0.5)
        modem.open(15); sleep(0.5)
        names = modem.getNamesRemote()
    end)
    if not s then print("warning: modem not found"); end
    return names
end

---getSimilarFromTable
---@param list table list from which to choose
---@param name string what to look for by prefix
---@param name table what to look for by prefix
---@return table list of matches
function Net.getSimilarFromTable(list, name)
    local names = {}
    if type(name) == "string" then
        for _, n in pairs(list) do
            if string.sub(n, 1, #name) == name then
                table.insert(names, n)
            end
        end
    elseif type(name) == "table" then
        for _, n in pairs(list) do
            for _, t in pairs(name) do
                if string.sub(n, 1, #t) == t then
                    table.insert(names, n)
                end
            end
        end
    end
    return names
end

return Net