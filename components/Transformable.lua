local Transformable = Component:extend("Transformable")

function Transformable:initialize(x, y, r)
    self.pos      = {}
    self.pos.x    = x or 0
    self.pos.y    = y or 0
    self.rotation = r or 0
end

function Transformable:getPosition()
    return self.pos.x, self.pos.y
end

function Transformable:setPosition(x, y)
    self.pos.x = x
    self.pos.y = y

    return self
end

function Transformable:getRotation()
    return self.rotation
end

function Transformable:setRotation(angle)
    self.rotation = r

    return self
end

function Transformable:getDistanceTo(entity)
    return ((entity.pos.x - self.pos.x) ^ 2 + (entity.pos.y - self.pos.y) ^ 2) ^ 0.5
end

function Transformable:move(dx, dy)
    self.pos.x, self.pos.y = self.pos.x + dx, self.pos.y + dy

    return self
end

function Transformable:rotate(delta_angle)
    self.rotation = (self.rotation + delta.angle) % math.pi*2

    return self
end
