FileUtils = {}

function FileUtils.readFile(file_name)
    local tabl={}
    local path = fs.getDir(shell.getRunningProgram())
    local file = path.."/"..file_name
    if fs.exists(file) then
        s, e = pcall(function()
            f = fs.open(file, "r")
            str = f.readLine()
            while str do
                if #str > 0 then
                    table.insert(tabl, str)
                end
                str = f.readLine()
            end
            f.close()
        end)
        if s then return true, tabl; end
        print("warning: FileUtils.readFile("..tostring(file_name)..") error")
        return false
    end
    print("warning: FileUtils.readFile("..tostring(file_name)..") missing")
    return false
end

function FileUtils.writeJSON(file_name, obj)
    local path = fs.getDir(shell.getRunningProgram())
    local file = path.."/"..file_name
    s, e = pcall(function()
        f = fs.open(file, "w")
        jsn = textutils.serializeJSON(obj)
        f.write(jsn)
        f.close()
    end)
    if s then return true; end
    print("warning: FileUtils.writeJSON("..tostring(file_name)..", obj) missing")
    return false
end

function FileUtils.readJSON(file_name)
    local obj
    local path = fs.getDir(shell.getRunningProgram())
    local file = path.."/"..file_name
    if fs.exists(file) then
        s, e = pcall(function()
            f = fs.open(file, "r")
            jsn = f.readAll()
            obj = textutils.unserializeJSON(jsn)
            f.close()
        end)
        if s then return true, obj; end
        print("warning: FileUtils.readJSON("..tostring(file_name)..") error")
        return false
    end
    print("warning: FileUtils.readJSON("..tostring(file_name)..") missing")
    return false
end







return FileUtils