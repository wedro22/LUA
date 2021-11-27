Periphery = {}

function Periphery:new(name)
    local obj = {}
    s, e = pcall(function()
        if type(name) == "string" then
            if (name == "left") or (name == "right")
                    or (name == "top") or (name == "bottom")
                    or (name == "back") or (name == "front") then
                obj.side = name
            else
                obj.name = name
            end
        else error("error: peripheral name"); end
        obj.type = peripheral.getType(name)
    end)
    if not s then print(e); return nil; end

    --modem-names OR nearby-sides
    function obj:getMethods()
        metods = {}
        s, e = pcall(function()
            if not obj.side then
                metods = peripheral.getMethods(obj.name)
            else
                metods = peripheral.getMethods(obj.side)
            end
        end); sleep(0.5)
        if not s then
            print("warning: peripheral no get Metods")
        end
        return metods
    end

    function obj:hasMetod(metod)
        for _, v in pairs(obj:getMethods()) do
            if v == metod then
                return true
            end
        end
        return false
    end

    ---@return table container as {{},{}}, or {}
    function obj:getContainer()
        list = {}
        if obj:hasMetod("list") then
            s, e = pcall(function()
                if obj.name then list = peripheral.call(obj.name, "list")
                else list = peripheral.call(obj.side, "list"); end
            end); sleep(0.5)
            if not s then
                print("warning: peripheral cant call list")
            end
        end
        return list
    end



    setmetatable(obj, self)
    self.__index = self
    return obj
end

return Periphery