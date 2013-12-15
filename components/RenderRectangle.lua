local RenderRectangle = Component:extend("RenderRectangle")

function RenderRectangle:initialize(w, h)
    self.width  = assert(w, "width not specified")
    self.height = assert(h, "height not specified")
end

function RenderRectangle:setSize(w, h)
    self.width  = w
    self.height = h

    return self
end

function RenderRectangle:draw()
	love.graphics.setColor(self.color)
    love.graphics.push()
        love.graphics.translate(self.pos.x, self.pos.y)
        love.graphics.rotate(self.rotation)
        love.graphics.translate(-self.pos.x, -self.pos.y)
        love.graphics.translate(-self.width/2, -self.height/2)
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
    love.graphics.pop()
end

-- http://developer.coronalabs.com/code/checking-if-point-inside-rotated-rectangle
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
