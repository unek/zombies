RenderCircle = Component:extend("RenderCircle")

function RenderCircle:initialize()
	self.radius = 5
end

function RenderCircle:setRadius(radius)
	self.radius = radius

	return self
end

function RenderCircle:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)
end