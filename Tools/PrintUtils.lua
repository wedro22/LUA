PrintUtils = {}
otostring = tostring -- origin tostring
PrintUtils.tostring = function (...)
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

return PrintUtils