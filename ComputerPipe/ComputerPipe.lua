path = fs.getDir(fs.getDir(shell.getRunningProgram()))
package.path = package.path..';/'..path..'/Tools/?.lua'

near = require("Nearby")
pr = require("PrintUtils")
container = require("ContainerUtils")
file = require("FileUtils")
