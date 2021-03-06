local Transformable = Component:extend("Transformable")

function Transformable:initialize(x, y, r, sx, sy)
    self.pos      = {}
    self.pos.x    = x or 0
    self.pos.y    = y or 0

    self.rotation = r or 0

    self.scale    = {}
    self.scale.x  = sx or 1
    self.scale.y  = sy or self.scale.x
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

function Transformable:getScale()
    return self.scale.x, self.scale.y
end

function Transformable:setScale(sx, sy)
    self.scale.x = x
    self.scale.y = y

    return self
end

function Transformable:getDistanceTo(entity)
    return MathUtils.dist(self.pos.x, self.pos.y, entity.pos.x, entity.pos.y)
end

function Transformable:move(dx, dy)
    self.pos.x, self.pos.y = self.pos.x + dx, self.pos.y + dy

    return self
end

function Transformable:rotate(delta_angle)
    self.rotation = (self.rotation + delta_angle) % math.pi * 2

    return self
end

function Transformable:lookAt(x, y)
    self.rotation = math.atan2(y - self.pos.y, x - self.pos.x)

    return self
end

function Transformable:getTransforms()
    return self.pos.x, self.pos.y, self.rotation, self.scale.x, self.scale.y
end