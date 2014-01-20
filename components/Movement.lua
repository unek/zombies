local Movement = Component:extend("Movement")

function Movement:initialize(speed)
    assert(self.physics_type ~= "static", "tried to add a Movement component to a static physical entity")
    self.speed      = speed or 200
    self.movement   = {}
    self.movement.x = 0
    self.movement.y = 0

    self.movable    = true
end

function Movement:move(x, y)
    self.movement.x = x or self.movement.x
    self.movement.y = y or self.movement.y

    return self
end

function Movement:update(dt)
    if not self.movable then return end
    if self.parent then
        self.movement.x, self.movement.y = 0
        return
    end
    local mx, my = MathUtils.normalize(self.movement.x, self.movement.y)
    self.physics_body:applyForce(mx * self.speed, my * self.speed)
end

function Movement:isMoveable()
    return self.movable
end

function Movement:setMovable(value)
    self.movable = value

    return self
end

function Movement:getMaxSpeed()
    return self.speed
end
