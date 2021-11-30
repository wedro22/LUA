net = require("Net")
nearby = require("Nearby")
periphery = require("Periphery")
printutils = require("PrintUtils")
fileutils = require("FileUtils")

t={1,2,3,{2,4,4}}
fileutils.writeJSON("asd", t)
state, tt = fileutils.readJSON("asd")
print(textutils.serialize(tt))






--package.path = package.path..';'..'lib/?.lua'
-----------------------------------
--local filename = "Net"
--local path = fs.getDir(shell.getRunningProgram())
--local file = path.."/"..filename..".lua"
--print(file)
--assert(fs.exists(file))
-----------------------------------