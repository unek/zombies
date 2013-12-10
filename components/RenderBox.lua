RenderBox = Component:extend("RenderBox")

function RenderBox:initialize()
    self.width  = 10
    self.height = 10
end

function RenderBox:setSize(w, h)
    self.width  = w
    self.height = h

    return self
end

function RenderBox:draw()
	love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
end
