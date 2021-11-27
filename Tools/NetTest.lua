local filename = "Net"
----------------------------------
local path = fs.getDir(shell.getRunningProgram())
local file = path.."/"..filename..".lua"
print(file)
assert(fs.exists(file))
r = require(filename)
----------------------------------
names = r.getNamesRemote()
for _, n in pairs(names) do
    print(n)
end