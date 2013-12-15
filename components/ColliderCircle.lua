local ColliderCircle = Component:extend("ColliderCircle")

function ColliderCircle:initialize(radius)
    local radius = assert(radius or self.radius, "radius not specified")
	self.physics_shape = love.physics.newCircleShape(radius)
end

function ColliderCircle:draw()
    if not game.console:getVariable("debug") then return end
    local radius = self.physics_shape:getRadius()
    love.graphics.setColor(255, 0, 0, 100)
    love.graphics.circle("fill", self.pos.x, self.pos.y, radius)
    love.graphics.setColor(255, 0, 0)
    love.graphics.circle("line", self.pos.x, self.pos.y, radius)
    local dx, dy = math.cos(self.physics_body:getAngle()) * radius, math.sin(self.physics_body:getAngle()) * radius
    love.graphics.line(self.pos.x, self.pos.y, self.pos.x + dx, self.pos.y + dy)
end

function ColliderCircle:setColliderRadius(radius)
	self.physics_shape:setRadius(radius)

	return self
end

function ColliderCircle:getColliderRadius(radius)
	return self.physics_shape:getRadius(radius)
end

function ColliderCircle:destroy()
    return self.physics_shape:destroy()
end