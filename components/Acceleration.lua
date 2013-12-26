local Acceleration = Component:extend("Acceleration")

function Acceleration:initialize()
    assert(self:hasComponent("Transformable"), "Entity needs a Transformable component")
    assert(self:hasComponent("Velocity"), "Entity needs a Velocity component")

    self.acceleration     = {}
    self.acceleration.x   = 0
    self.acceleration.y   = 0
end

function Acceleration:getAcceleration()
    return self.acceleration.x, self.acceleration.y
end

function Acceleration:setAcceleration(x, y)
    self.acceleration.x = x or self.acceleration.x
    self.acceleration.y = y or self.acceleration.y

    return self
end

function Acceleration:update(dt)
    local vX, vY = self:getVelocity()
    local aX, aY = self:getAcceleration()

    vX = vX + aX*dt
    vY = vY + aY*dt

    self:setVelocity(vX, vY)
end