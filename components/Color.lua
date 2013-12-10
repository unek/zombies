Color = Component:extend("Color")

function Color:initialize()
	self.color = {255, 255, 255, 255}
end

function Color:setColor(color, g, b, a)
	if type(color) == "number" then
		color = {color, g, b, a}
	end
	
	self.color = color

	return self
end
