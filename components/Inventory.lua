local Inventory = Component:extend("Inventory")

function Inventory:initialize(slots)
    self.size  = slots or 4
    self.items = {}
end

function Inventory:giveItem(item_class, count, properties)
    local count = count
    -- if player already has the item, increase current stack
    for _, item in pairs(self.items) do
        if item.object.class == item_class then
            local i    = math.min(count, item_class.MAX_STACK - item.count)
            item.count = item.count + i
            count      = count - i

            if count < 1 then return true end
        end
    end
    if #self.items < self.size then
        local item  = {}
        item.object = item_class:new(properties)
        item.count  = count
        table.insert(self.items, item)

        return true
    end

    return false
end

function Inventory:takeItem(item_class, count)
    local count = count
    -- iterate over items and remove
    for _, item in pairs(self.items) do
        if item.object.class == item_class then
            local i    = math.max(0, item.count - count)
            count      = count - i
            item.count = item.count - i

            if count < 1 then return true end
        end
    end

    return false, count
end

function Inventory:hasItem(item_class, count)
    local count = count or 1
    local has   = 0
    for _, item in pairs(self.items) do
        if item.object.class == item_class then
            has = has + item.count
        end
    end

    return has >= count
end