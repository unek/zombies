local RenderCircle = Component:extend("RenderCircle")

function RenderCircle:initialize(radius, segments)
    self:setRenderRadius(radius, segments)
end

function RenderCircle:draw()
    local x, y, r, sx, sy, ox, oy = self:getTransforms()
    if self.fill_color then
        love.graphics.setColor(self.fill_color)
    else
        love.graphics.setColor(255, 255, 255)
    end

    love.graphics.draw(self.mesh, x, y, r, sx, sy)
end

function RenderCircle:setRenderRadius(radius, segments)
    -- generate vertices
    local vertices = {}
    local segments = segments or radius
    for i = 0, segments do
        local theta = (i / segments) * math.pi * 2

        local x, y = math.cos(theta) * radius, math.sin(theta) * radius
        local u, v = (x + radius) / radius / 2, (y + radius) / radius / 2

        table.insert(vertices, { x, y, u, v })
    end

    if self.mesh then
        self.mesh:setVertices(vertices)
    else
        self.mesh = love.graphics.newMesh(vertices)
    end

    self.radius = radius
end

function RenderCircle:testPoint(x, y)
    return (((x - self.pos.x) ^ 2 + (y - self.pos.y) ^ 2) ^ 0.5) <= self.radius
end

