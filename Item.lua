local Item = Class("game.Item")

function Item:initialize(owner, amount)
    self.name   = "Item"

    self.owner  = owner

    self.amount    = amount or 1
    self.max_stack = 16
end

function Item:extend(name)
    local class = Class("game.items." .. name, Item)
    game.item_registry[name] = class
    return class
end

function Item:stacksWith(item_class)
    return self.class == item_class
end

function Item:draw()

end

function Item:use()

end

function Item:add(amount)
    self.amount = math.min(self.max_stack, math.self.amount + amount)
end

function Item:take(amount)
    self.amount = self.amount - amount

    if self.amount < 1 then
        self:destroy()
    end
end

function Item:destroy()
    for slot, item in pairs(self.owner.inv_items) do
        if item == self then
            self.owner.inv_items[slot] = nil
        end
    end
end

function Item:isHeld()
    return self.owner and self.owner:getCurrentItem() == self
end

return Item
