local Sprite = Component:extend("Sprite")

function Sprite:initialize(image, w, h)
    self.image  = assert(image:type() == "Image" and image, "first argument must be an image")
    self.width  = w or self.image:getWidth()
    self.height = h or self.image:getHeight()
end

function Sprite:draw()
    local sx = (self.width / self.image:getWidth()) * self.scale.x
    local sy = (self.height / self.image:getHeight()) * self.scale.y
    love.graphics.draw(self.image, self.pos.x, self.pos.y, self.rotation, sx, sy, (self.width/2)/sx, (self.height/2)/sy)
end

function Sprite:setImage(image)
    self.image = assert(image:type() == "Image" and image, "first argument must be an image")
end

function Sprite:setWidth(w)
    self.width = w
    
    return self
end

function Sprite:setHeight(h)
    self.height = h
    
    return self
end

function Sprite:setSize(w, h)
    self.width  = w
    self.height = h

    return self
end

-- http://developer.coronalabs.com/code/checking-if-point-inside-rotated-rectangle
function Sprite:testPoint(x, y)
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
