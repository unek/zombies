local RenderRectangle = Component:extend("RenderRectangle")

function RenderRectangle:initialize(w, h)
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

function RenderRectangle:draw()
    local x, y, r, sx, sy, ox, oy = self:getTransforms()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.mesh, x, y, r, sx, sy)
end

function RenderRectangle:setWidth(w)
    self.width = w
    self.mesh:setVertex(3, self.width, self.height, 1, 1)
    self.mesh:setVertex(4, self.width, 0, 1, 0)

    return self
end

function RenderRectangle:setHeight(h)
    self.height = h
    self.mesh:setVertex(2, 0, self.height, 0, 1)
    self.mesh:setVertex(3, self.width, self.height, 1, 1)

    return self
end

function RenderRectangle:setSize(w, h)
    return self:setWidth(w):setHeight(h)
end

function RenderRectangle:testPoint(x, y)
    local c = math.cos(-self.rotation)
    local s = math.sin(-self.rotation)
    
    -- UNrotate the point depending on the rotation of the rectangle
    local rotatedX = self.pos.x + c * (x - self.pos.x) - s * (y - self.pos.y)
    local rotatedY = self.pos.y + s * (x - self.pos.x) + c * (y - self.pos.y)
    
    -- perform a normal check if the new point is inside the 
    -- bounds of the UNrotated rectangle
    local leftX = self.pos.x - self.width / 2
    local rightX = self.pos.x + self.width / 2
    local topY = self.pos.y - self.height / 2
    local bottomY = self.pos.y + self.height / 2
    
    return leftX <= rotatedX and rotatedX <= rightX and
        topY <= rotatedY and rotatedY <= bottomY
end