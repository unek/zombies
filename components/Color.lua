Color = Component:extend("Color")

function Color:initialize(color, g, b, a)
    if type(color) == "number" then
        color = {color, g, b, a}
    end
    
    self.color = color
end

function Color:setColor(color, g, b, a)
	if type(color) == "number" then
		color = {color, g, b, a}
	end
	
	self.color = color

	return self
end
