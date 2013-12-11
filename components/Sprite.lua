Sprite = Component:extend("Sprite")

function Sprite:initialize(image, w, h)
    self.image  = assert(image:type() == "Image" and image, "first argument must be an image")
    self.width  = w or self.image:getWidth()
    self.height = h or self.image:getHeight()
end

function Sprite:draw()
    local sx = self.width / self.image:getWidth()
    local sy = self.height / self.image:getHeight()
    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.push()
        love.graphics.translate(self.pos.x, self.pos.y)
        love.graphics.rotate(self.rotation)
        love.graphics.translate(-self.pos.x, -self.pos.y)
        love.graphics.translate(-self.width/2, -self.height/2)
        love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, sx, sy)
    love.graphics.pop()
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
