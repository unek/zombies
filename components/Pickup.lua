local Pickup = Component:extend("Pickup")

function Pickup:initialize(item)
    self.pickup_radius = 30
    self.pickup_item   = item
end

function Pickup:update(dt)
    for _, entity in pairs(self.world.entities) do
        if entity:hasComponent("Inventory") and entity:getDistanceTo(self) <= self.pickup_radius then
            local success, left = entity:giveItem(self.pickup_item)

            if success then
                self:destroy()
            else
                self.pickup_amount = left
            end

            return
        end
    end
end

function Pickup:draw()
    -- compute radius
    local radius = self.pickup_radius + math.sin(love.timer.getTime() * 2) * self.pickup_radius * 0.05
    -- outline
    love.graphics.setLineWidth(2)
    love.graphics.setColor(0, 180, 255, 40)
    love.graphics.circle("fill", self.pos.x, self.pos.y, radius)
    love.graphics.setColor(0, 180, 255)
    love.graphics.circle("line", self.pos.x, self.pos.y, radius)
    
    -- item sprite
    if self.pickup_item.draw then
        self.pickup_item:draw(self.pos.x, self.pos.y)
    end
end
