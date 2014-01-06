local Button = hud.registry.Object:extend("Button")

function Button:initialize(parent, x, y, w, h)
    hud.registry.Object.initialize(self, parent, x, y, w, h)

    self.height = h or 40

    self.label  = "Button"
    self.font   = game.assets:getFont("Roboto-Bold")[19]
end

function Button:setLabel(label)
    self.label = label

    return self
end

function Button:draw()
    -- draw the background
    if self:isHovered() then
        love.graphics.setColor(20, 20, 20)
    else
        love.graphics.setColor(0, 0, 0)
    end
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)

    -- outline
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.width, self.height)

    -- calculate text position and print it
    local tw = self.font:getWidth(self.label)
    local th = self.font:getHeight()
    local x  = self.pos.x + (self.width - tw) / 2
    local y  = self.pos.y + (self.height - th) / 2

    love.graphics.setFont(self.font)
    love.graphics.print(self.label, x, y)
end

function Button:mousereleased(x, y, button)
    if button ~= "l" then return end
    self:emit("push")
end
