local HealthIndicator = Component:extend("HealthIndicator")

function HealthIndicator:initialize(radius)
	self.indicator_radius = radius or self.radius + 5
end

function HealthIndicator:draw()
	local color    = (self.health / self.max_health) * 255
	local vertices = {}
	local tau      = math.pi * 2

	love.graphics.setColor(255 - color, color, 255)
	love.graphics.setLineWidth(3)

	for angle = 0, self.health / self.max_health * tau, tau / 20 do
		table.insert(vertices, self.pos.x + math.cos(angle) * self.indicator_radius)
		table.insert(vertices, self.pos.y + math.sin(angle) * self.indicator_radius)
	end

	if #vertices >= 4 then
		love.graphics.line(unpack(vertices))
	end
	
	love.graphics.setLineWidth(1)
end

return HealthIndicator
