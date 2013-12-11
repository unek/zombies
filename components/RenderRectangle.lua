RenderRectangle = Component:extend("RenderRectangle")

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
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end
