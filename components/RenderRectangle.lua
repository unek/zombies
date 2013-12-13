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
