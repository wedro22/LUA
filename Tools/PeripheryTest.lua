local filename = "Periphery"
----------------------------------
r = require(filename)
pr = require("PrintUtils")
----------------------------------


chest = r:new("left")
is, list = chest:getMetadata()
chest:pushItems("right", 1, 1, 1)
print(pr.tostring(list))