local filename = "Nearby"
----------------------------------
local path = fs.getDir(shell.getRunningProgram())
local file = path.."/"..filename..".lua"
print(file)
assert(fs.exists(file))
r = require(filename)
----------------------------------
names = r.getTypes()
for s, n in pairs(names) do
    print(s, n)
end
names = r.getSimilarFromTable(r.getTypes(), {"minecraft:"})
for s, n in pairs(names) do
    print(s, n)
end