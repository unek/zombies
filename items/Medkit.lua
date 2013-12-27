local Medkit = Item:extend("Medkit")

function Medkit:initialize(owner, amount)
    Item.initialize(self, owner, amount)
    self.name      = "Medkit"
    self.max_stack = 1

    self.health    = 75
end

function Medkit:use()
    if self.owner.health >= self.owner.max_health then return end
    self.owner:heal(self.health)
    self:destroy()
end

function Medkit:draw(x, y, size)
    love.graphics.push()
    love.graphics.translate(x - 16, y - 14)
        -- side
        love.graphics.setColor(70, 0, 0)
        love.graphics.rectangle("fill", 0, 4, 32, 24)

        -- red rectangle
        love.graphics.setColor(170, 0, 0)
        love.graphics.rectangle("fill", 0, 0, 32, 24)

        -- plus sign
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("fill", 14, 4, 4, 16)
        love.graphics.rectangle("fill", 8, 10, 16, 4)
    love.graphics.pop()
end
