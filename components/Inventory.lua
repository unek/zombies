local Inventory = Component:extend("Inventory")

function Inventory:initialize(slots)
    self.inv_size  = slots or 4
    self.inv_items = {}
end

function Inventory:giveItem(item_object, count)
    local count = count or 1
    for _, item in pairs(self.inv_items) do
        -- if player already has the same item in inventory
        if item.object:isInstanceOf(item_object.class) then
            -- add as much as possible to the stack
            local add  = math.min(item.object.class.MAX_STACK - item.count, count)
            item.count = item.count + add
            count      = count - add
        end

        if count < 1 then return true end
    end

    if #self.inv_items < self.inv_size then
        local item  = {}
        item.object = item_object
        item.count  = math.min(item_object.class.MAX_STACK, count)
        table.insert(self.inv_items, item)

        if count - item.count > 0 then
            return self:giveItem(item_object, count - item.count)
        end

        return true
    end

    return false, count
end


function Inventory:consumeItem(item_name, count)
    local item_class = game.item_registry[item_name]
    local count = count or 1
    -- iterate over items and remove
    for _, item in pairs(self.inv_items) do
        if item.object:isInstanceOf(item_class) then
            local i    = math.max(0, item.count - count)
            count      = count - i
            item.count = item.count - i

            if count < 1 then return true end
        end
    end

    return false, count
end

function Inventory:hasItem(item_name, count)
    local item_class = game.item_registry[item_name]
    local count = count or 1
    local has   = 0
    for _, item in pairs(self.inv_items) do
        if item.object:isInstanceOf(item_class) then
            has = has + item.count
        end
    end

    return has >= count
end

function Inventory:getInventorySlot(i)
    return self.inv_items[i]
end
