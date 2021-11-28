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
    ---@return table methods list as {}
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

    function obj:hasMethod(method)
        for _, v in pairs(obj:getMethods()) do
            if v == method then
                return true
            end
        end
        return false
    end


    ---request_shield Non-crash-inducing peripheral call
    ---@param method_name string
    ---@param [...] string args of method
    ---@return boolean status,
    ---@return [call result] or [string] error message if status == false ("method is missing", "error")
    function obj:request_shield(method_name, ...)
        local ret
        if not obj:hasMethod(method_name) then return false, "method is missing"; end
        s, e = pcall(function()
            if obj.name then ret = peripheral.call(obj.name, method_name, ...)
            else ret = peripheral.call(obj.side, method_name, ...); end
        end); sleep(0.5)
        if s then return true, ret; end
        --if error \/
        if type(method_name)=="string" then
            write("warning: peripheral cant call: "..method_name)
            if ... then
                args = {...}
                ss, ee = pcall(function()
                    for k, v in pairs(args) do
                        write("; arg"..k..":"..v)
                    end
                end)
                if ss then print(".")
                else print("; invalid args"); end
            else print("."); end
        else print("warning: peripheral cant call: invalid method_name"); end
        return false, "error"
    end

    ---getList peripheral storage list
    ---@return [state],[table/string error)]
    function obj:getList()
        return obj:request_shield("list")
    end

    ---getMetadata peripheral metadata list
    ---@param property
    ---@return [state],[table/property/string error)]
    function obj:getMetadata(property)
        state, list = obj:request_shield("getMetadata")
        if state and property then return state, list[property]; end
        return state, list
    end



    setmetatable(obj, self)
    self.__index = self
    return obj
end

return Periphery