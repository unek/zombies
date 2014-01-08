local RenderRectangleShape = Component:extend("RenderRectangleShape")

function RenderRectangleShape:initialize(w, h)
    -- generate vertices
    local vertices = {}
    vertices[1] = {0, 0, 0, 0}
    vertices[2] = {0, h, 0, 1}
    vertices[3] = {w, h, 1, 1}
    vertices[4] = {w, 0, 1, 0}

    self.mesh   = love.graphics.newMesh(vertices)
    self.width  = w
    self.height = h
end

function RenderRectangleShape:draw()
    local x, y, r, sx, sy, ox, oy = self:getTransforms()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.mesh, x, y, r, sx, sy)
end