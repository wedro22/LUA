ContainerUtils = {}
local itm = require("Item")

function ContainerUtils.listContain(list, item)
    for k, v in pairs(list) do
        if itm.compare(v, item) then
            return k
        end
    end
    return false
end

function ContainerUtils.takeFromTo(from_container, slot_item, to_container)
    asddsdasasd
end

return ContainerUtils