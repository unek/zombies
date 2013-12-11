Physics = Component:extend("Physics")

function Physics:initialize(type)
    assert(self:hasComponent("Position"), "entity needs a Position component")
    assert(self:hasComponent("Rotation"), "entity needs a Rotation component")
	assert(self.physics_shape, "entity needs a Collision shape component")

    self.physics_type    = assert((type == "dynamic" or type == "kinetic" or type == "static") and type, "type invalid")
    self.physics_body    = love.physics.newBody(game.world.world, self.pos.x, self.pos.y, self.physics_type)
    self.physics_fixture = love.physics.newFixture(self.physics_body, self.physics_shape)

    self.physics_body:setLinearDamping(10)
    self.physics_body:setAngularDamping(1)

    self.physics_body:setPosition(self.pos.x, self.pos.y)
    self.physics_body:setAngle(self.rotation)

    self.physics_fixture:setUserData(self.id)
end

function Physics:destroy()
	self.physics_body:destroy()
end

function Physics:update(dt)
	self.pos.x, self.pos.y = self.physics_body:getPosition()
    self.rotation = self.physics_body:getAngle()
end

-- aims to overwrite Position's original setPosition.
function Physics:setPosition(x, y)
    self.physics_body:setPosition(x, y)
    self.pos.x, self.pos.y = x, y

    return self
end

-- aims to overwrite Rotation's original setRotation.
function Physics:setRotation(angle)
    self.physics_body:setAngle(angle)
    self.rotation = angle

    return self
end