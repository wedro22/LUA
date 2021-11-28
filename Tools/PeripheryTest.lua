local filename = "Periphery"
----------------------------------
local path = fs.getDir(shell.getRunningProgram())
local file = path.."/"..filename..".lua"
print(file)
assert(fs.exists(file))
r = require(filename)
----------------------------------

otostring = tostring -- origin tostring
tostring = function (...)
    if type(...) == "table" then
        local str = '{'
        for i,v in pairs(...) do
            local pre = type(i) == "string" and i.."=" or ""
            str = str .. pre..tostring(v) .. ", "
        end
        str = str:sub(1, -3)
        return str..'}'
    else
        return otostring(...)
    end
end

chest = r:new("left")
list = chest:getMetadata()
print(tostring(list))