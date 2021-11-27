Net = {}

---getNames List all remote peripherals on the wired network
---@return table names
function Net.getNamesRemote()
    names = {}
    --s, e = pcall(openModem)
    --if not pcall(openModem) then msg("modem error"); end
    s, e = pcall(function()
        modem = peripheral.find("modem").open(15)
        names = modem.getNamesRemote()
    end)
    if not s then print("warning: modem not found"); end
    return names
end

return Net