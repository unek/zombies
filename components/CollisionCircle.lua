CollisionCircle = Component:extend("CollisionCircle")

function CollisionCircle:initialize()
	self.physics_shape = love.physics.newCircleShape(self.pos.x, self.pos.y, 5)
end

function CollisionCircle:setCollisionRadius(radius)
	self.physics_shape:setRadius(radius)

	return self
end

function CollisionCircle:getCollisionRadius(radius)
	return self.physics_shape:getRadius(radius)
end
