ColliderRectangle = Component:extend("ColliderRectangle") 

function ColliderRectangle:initialize(w, h)
    local w = assert(w or self.width, "width not specified")
    local h = assert(h or self.height, "height not specified")
    self.physics_shape  = love.physics.newRectangleShape(w, h)

    self.physics_width  = w
    self.physics_height = h
end

function ColliderRectangle:destroy()
    return self.physics_shape:destroy()
end

function ColliderRectangle:draw()
    if not game.debug then return end
    love.graphics.setColor(255, 0, 0)
    love.graphics.polygon("line", self.physics_body:getWorldPoints(self.physics_shape:getPoints()))
end

function ColliderRectangle:setColliderSize(w, h)
    self.physics_width  = w
    self.physics_height = h

    -- we have to make a new shape
    self.physics_fixture:destroy()

    self.physics_shape   = love.physics.newRectangleShape(w, h)
    self.physics_fixture = love.physics.newFixture(self.physics_body, self.physics_shape)

    return self
end
