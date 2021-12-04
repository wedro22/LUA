Item = {}

function Item.isItem(tabl)
    if tabl.name and tabl.damage then
        return true
    end
    return false
end

function Item.compare(item1, item2)
    if (not Item.isItem(item1)) or (not Item.isItem(item2)) then
        return false
    end
    if (item1.name == item2.name) and (item1.damage == item2.damage) then
        return true
    end
    return false
end

function Item:new(tabl)
    local obj = {}
    if not Item:isItem(tabl) then return nil; end
    obj = tabl

    function obj:compare(item2)
        return Item.compare(obj, item2)
    end




    setmetatable(obj, self)
    self.__index = self
    return obj
end

return Item