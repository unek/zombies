local Medkit = game.item_registry.Consumable:extend("Medkit")

Medkit.static.MAX_STACK = 1

function Medkit:initialize(health)
	self.name = "Medkit"
end

function Medkit:consume()

end

function Medkit:draw(x, y)
	love.graphics.push()
	love.graphics.translate(x - 16, y -12)
		-- side
		love.graphics.setColor(70, 0, 0)
		love.graphics.rectangle("fill", 0, 3, 32, 24)

		-- red rectangle
		love.graphics.setColor(170, 0, 0)
		love.graphics.rectangle("fill", 0, 0, 32, 24)

		-- plus sign
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", 14, 4, 4, 16)
		love.graphics.rectangle("fill", 8, 10, 16, 4)
	love.graphics.pop()
end
