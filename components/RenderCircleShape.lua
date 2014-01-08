local RenderCircleShape = Component:extend("RenderCircleShape")

function RenderCircleShape:initialize(radius, segments)
    -- generate vertices
    local vertices = {}
    local segments = segments or radius
    for i = 0, segments do
        local theta = (i / segments) * math.pi * 2

        local x, y = math.cos(theta) * radius, math.sin(theta) * radius
        local u, v = x / radius, y / radius

        table.insert(vertices, { x, y, u, v })
    end

    self.mesh   = love.graphics.newMesh(vertices)
    self.radius = radius
end

function RenderCircleShape:draw()
    local x, y, r, sx, sy, ox, oy = self:getTransforms()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.mesh, x, y, r, sx, sy)
end
