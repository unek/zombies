local Sprite = Component:extend("Sprite")

function Sprite:initialize(image, w, h)
    self.image  = assert(image:typeOf("Drawable") and image, "first argument must be a drawable")
    self.width  = w or self.image:getWidth()
    self.height = h or self.image:getHeight()
end

function Sprite:draw()
    local sx = (self.width / self.image:getWidth()) * self.scale.x
    local sy = (self.height / self.image:getHeight()) * self.scale.y

    local _, _, _, alpha = love.graphics.getColor()
    if self.fill_color then
        local r, g, b, a = unpack(self.fill_color)
        love.graphics.setColor(r, g, b, (a * alpha) / 2)
    else
        love.graphics.setColor(255, 255, 255, alpha)
    end

    love.graphics.draw(self.image, self.pos.x, self.pos.y, self.rotation, sx, sy, (self.width / 2 ) / sx, (self.height / 2) / sy)
end

function Sprite:setImage(image)
    self.image = assert(image:typeOf("Drawable") and image, "first argument must be a drawable")
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

-- thanks Zer0 for these methods!
function Sprite:computeCorners()
    local x, y = self.pos.x, self.pos.y
    local w, h = self.width * self.scale.x, self.height * self.scale.y
    local r    = self.rotation

    local r1 = math.atan2(h, w)
    local r2 = math.atan2(-h, w)
    local r3 = math.atan2(-h, -w)
    local r4 = math.atan2(h, -w)

    local d = math.sqrt((h / 2) ^ 2 + (w / 2) ^ 2)

    local x1, y1 = x + math.cos(r1 + r) * d, y + math.sin(r1 + r) * d
    local x2, y2 = x + math.cos(r2 + r) * d, y + math.sin(r2 + r) * d
    local x3, y3 = x + math.cos(r3 + r) * d, y + math.sin(r3 + r) * d
    local x4, y4 = x + math.cos(r4 + r) * d, y + math.sin(r4 + r) * d

    return x1, y1, x2, y2, x3, y3, x4, y4
end

function Sprite:computeAABB()
    local x1, y1, x2, y2, x3, y3, x4, y4 = self:computeCorners()

    local bx, by = math.min(x1, x2, x3, x4), math.min(y1, y2, y3, y4)
    local tx, ty = math.max(x1, x2, x3, x4), math.max(y1, y2, y3, y4)

    return bx, by, tx - bx, ty - by
end
