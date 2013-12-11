Position = Component:extend("Position")

function Position:initialize(x, y)
    self.pos   = {}
    self.pos.x = x or 0
    self.pos.y = y or 0
end

function Position:getPosition()
    return self.pos.x, self.pos.y
end

function Position:setPosition(x, y)
    self.pos.x = x
    self.pos.y = y

    return self
end
