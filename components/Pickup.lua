local Pickup = Component:extend("Pickup")

function Pickup:initialize(item, prompt)
    self.pickup_radius = 30
    self.pickup_item   = item
    self.pickup_prompt = prompt
end

function Pickup:update(dt)
    for _, entity in pairs(self.world.entities) do
        -- this could be a one-liner but... meh.
        local pickup = false
        if self.pickup_prompt then
            if game.player == entity then
                pickup = game.input:isDown("use")
            end
        else
            pickup = true
        end

        if pickup and entity:hasComponent("Inventory") and entity:getDistanceTo(self) <= self.pickup_radius then
            entity:giveItem(self.pickup_item)
            if self.pickup_item.owner then
                self:destroy()
            end
        end
    end
end

function Pickup:draw()
    -- pulsating radius
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
