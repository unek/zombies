local RenderCircle = Component:extend("RenderCircle")

function RenderCircle:initialize(radius)
	self.radius = assert(radius, "radius not specified")
end

function RenderCircle:setRadius(radius)
	self.radius = radius

	return self
end

function RenderCircle:draw()
	love.graphics.setColor(self.color)
	love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)
end

function RenderCircle:testPoint(x, y)
    return (((x - self.pos.x) ^ 2 + (y - self.pos.y) ^ 2) ^ 0.5) <= self.radius
end
