local Inventory = Component:extend("Inventory")

function Inventory:initialize(slots)
    self.inv_size  = slots or 4
    self.inv_items = {}

    self.inv_selected = 1
end

function Inventory:giveItem(item)
    if #self.inv_items < self.inv_size then
        table.insert(self.inv_items, item)

        return true
    else
        local slot
        for _, inv_item in pairs(self.inv_items) do
            if inv_item:stackWith(item.class) then
                local max = math.min(inv_item.max_stack - inv_item.amount, amount)
                inv_item:add(max)
                inv_item:take(max)
                amount = amount - max
            end
        end

        return amount > 0, amount
    end
end

function Inventory:getCurrentItem()
    return self.inv_items[self.inv_selected]
end

