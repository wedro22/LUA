Net = {}
Net.names = {}

local function msg(message, sleep_time)
    if message then print(message); end
    if sleep_time then sleep(sleep_time); end
end

function Net.refresh(canal)
    function openModem()
        modem = peripheral.find("modem")
        if canal then modem.open(canal);
            else modem.open(15); end
    end
    xpcall(openModem(), msg("modem not found", 20))
    names = modem.getNamesRemote()

end

return Net
