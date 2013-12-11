ColliderRectangle = Component:extend("ColliderRectangle")

function ColliderRectangle:initialize(w, h)
    local w = assert(w or self.width, "width not specified")
    local h = assert(h or self.height, "height not specified")
    self.physics_shape  = love.physics.newRectangleShape(self.pos.x, self.pos.y, w, h)
    self.physics_width  = w
    self.physics_height = h
end

function ColliderRectangle:destroy()
    return self.physics_shape:destroy()
end
