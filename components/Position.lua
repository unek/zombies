Position = Component:extend("Position")

function Position:initialize()
    print("Position component initialized")

    self.pos   = {}
    self.pos.x = 0
    self.pos.y = 0
end

function Position:getPosition()
    return self.pos.x, self.pos.y
end