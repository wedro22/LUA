Item = {}

function Item.isItem(obj)
    if obj.name and obj.damage then
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

return Item