local filename = "Periphery"
----------------------------------
local path = fs.getDir(shell.getRunningProgram())
local file = path.."/"..filename..".lua"
print(file)
assert(fs.exists(file))
r = require(filename)
----------------------------------
chest = r.new("left")
for s, n in pairs(chest) do
    print(s, n)
end
list = chest:getContainer()
for s, n in pairs(list) do
    print(s, n)
end
