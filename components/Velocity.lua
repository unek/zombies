Velocity = Component:extend("Velocity")

function Velocity:initialize()
    assert(self:hasComponent("Position"), "Entity needs a Position component")

    self.velocity     = {}
    self.velocity.x   = 0
    self.velocity.y   = 0
    self.velocity.max = 250
end

function Velocity:getVelocity()
    return self.velocity.x, self.velocity.y
end

function Velocity:setVelocity(x, y)
    local length = (x*x + y*y)^0.5
    local max    = math.min(self.velocity.max, length)

    self.velocity.x = x/length*max
    self.velocity.y = y/length*max

    return self
end

function Velocity:getMaxVelocity()
    return self.velocity.max
end

function Velocity:setMaxVelocity(max)
    self.velocity.max = max

    return self
end

function Velocity:update(dt)
    local  x,  y = self:getPosition()
    local vX, vY = self:getVelocity()

    x = x + vX*dt
    y = y + vY*dt

    self:setPosition(x, y)
end