FileUtils = {}

function FileUtils.readFile(file_name)
    local tabl={}
    local path = fs.getDir(shell.getRunningProgram())
    local file = path.."/"..file_name
    if fs.exists(file) then
        f = fs.open(file, "r")
        str = f.readLine()
        while str do
            if #str > 0 then
                table.insert(tabl, str)
            end
            str = f.readLine()
        end
        f.close()
        return true, tabl
    end
    return false
end

function FileUtils.writeJSON(file_name, obj)
    local path = fs.getDir(shell.getRunningProgram())
    local file = path.."/"..file_name
    f = fs.open(file, "w")
    jsn = textutils.serializeJSON(obj)
    f.write(jsn)
    f.close()
    return true, obj
end

function FileUtils.readJSON(file_name)
    local obj
    local path = fs.getDir(shell.getRunningProgram())
    local file = path.."/"..file_name
    if fs.exists(file) then
        f = fs.open(file, "r")
        jsn = f.readAll()
        obj = textutils.unserializeJSON(jsn)
        f.close()
        return true, obj
    end
    return false
end







return FileUtils