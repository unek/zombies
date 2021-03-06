local Inventory = Component:extend("Inventory")

function Inventory:initialize(slots)
    self.inv_size  = slots or 4
    self.inv_items = {}

    self.inv_selected = 1
end

function Inventory:getItemAmount()
    local amount = 0
    for _, item in pairs(self.inv_items) do
        if item then
            amount = amount + 1
        end
    end

    return amount
end

function Inventory:giveItem(item)
    if self:getItemAmount() < self.inv_size then
        -- insert into current or first free slot
        if not self:getCurrentItem() then
            self.inv_items[self.inv_selected] = item
            item.owner = self

            return true
        end
        for i = 1, self.inv_size do
            if not self.inv_items[i] then
                self.inv_items[i] = item
                item.owner = self

                return true
            end
        end
        item.owner = self

        return false
    else
        for _, inv_item in pairs(self.inv_items) do
            if inv_item:stacksWith(item.class) then
                local max = math.min(inv_item.max_stack - inv_item.amount, item.amount)
                inv_item:add(max)
                item:take(max)
            end
        end

        return item.amount < 1, item.amount
    end
end

function Inventory:getCurrentItem()
    return self.inv_items[self.inv_selected]
end

function Inventory:dropItem()
    local item = self:getCurrentItem()
    if item then
        local pickup = self.world:spawnPickup(self.pos.x, self.pos.y, item)
        pickup.pickup_prompt = true

        self.inv_items[self.inv_selected] = nil
        item.owner = nil
    end
end

function Inventory:useItem(single)
    if self.parent and self.parent.useItem then
        return self.parent:useItem(single)
    end
    local item = self:getCurrentItem()
    if item and item.use then
        item:use(single)
    end
end

function Inventory:reloadItem()
    if self.parent and self.parent.reloadItem then
        return self.parent:reloadItem()
    end
    local item = self:getCurrentItem()
    if item and item.reload then
        item:reload()
    end
end

function Inventory:shootItem(single)
    if self.parent and self.parent.shootItem then
        return self.parent:shootItem(single)
    end
    local item = self:getCurrentItem()
    if item and item.shoot then
        item:shoot(single)
    end
end

function Inventory:update(dt)
    if self == game.player and game.input:justPressed("drop") then
        self:dropItem()
    end
    for _, item in pairs(self.inv_items) do
        if item and item.update then item:update(dt) end
    end
end