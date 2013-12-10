Box = Component:extend("Box")

function Box:initialize()
    self.width  = 10
    self.height = 10
end

function Box:setSize(w, h)
    self.width  = w
    self.height = h

    return self
end

function Box:draw()
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end
