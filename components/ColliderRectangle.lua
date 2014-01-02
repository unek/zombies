local ColliderRectangle = Component:extend("ColliderRectangle") 

function ColliderRectangle:initialize(x, y, w, h)
    local w = assert(w or self.width, "width not specified")
    local h = assert(h or self.height, "height not specified")
    self.physics_shape  = love.physics.newRectangleShape(x or 0, y or 0, w, h)

    self.physics_width  = w
    self.physics_height = h
end

function ColliderRectangle:draw()
    if not game.console:getVariable("debug") then return end
    love.graphics.setColor(255, 0, 0, 100)
    love.graphics.polygon("fill", self.physics_body:getWorldPoints(self.physics_shape:getPoints()))
    love.graphics.setColor(255, 0, 0)
    love.graphics.polygon("line", self.physics_body:getWorldPoints(self.physics_shape:getPoints()))
    love.graphics.setColor(255, 255, 255)
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
