local Sprite = Component:extend("Sprite")

function Sprite:initialize(image, w, h)
    self.image  = assert(image:type() == "Image" and image, "first argument must be an image")
    self.width  = w or self.image:getWidth()
    self.height = h or self.image:getHeight()
end

function Sprite:draw()
    local sx = self.width / self.image:getWidth()
    local sy = self.height / self.image:getHeight()
    love.graphics.setColor(255, 255, 255, 255)
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
