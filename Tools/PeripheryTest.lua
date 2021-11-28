local filename = "Periphery"
----------------------------------
--local path = fs.getDir(shell.getRunningProgram())
--local file = path.."/"..filename..".lua"
--print(file)
--assert(fs.exists(file))
r = require(filename)
pr = require("PrintUtils")
----------------------------------



chest = r:new("left")
is, list = chest:getMetadata()
chest:pushItems("right", 1, 1, 1)
print(pr.tostring(list))