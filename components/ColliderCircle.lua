ColliderCircle = Component:extend("ColliderCircle")

function ColliderCircle:initialize(radius)
    local radius = assert(radius or self.radius, "radius not specified")
	self.physics_shape = love.physics.newCircleShape(radius)
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