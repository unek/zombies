local Light = Component:extend("Light")

function Light:initialize(color, radius, intensity, ox, oy)
	if not game.console:getVariable("lighting") then return end

	self.light = {
		  position = { self.pos.x + (ox or 0), self.pos.y + (oy or 0), 60 }
		, color = color or {255, 255, 255}
		, radius = radius or 128
		, intensity = intensity or 1.5
	}

	self.light_offset = { x = ox or 0, y = oy or 0 }

	self.light_id = -1

	for i = 1, self.world.max_lights do
		if not self.world.lights[i] then
			self.light_id = i
			break
		end
	end
	self.world.lights[self.light_id] = self.light
end

function Light:update(dt)
	if not game.console:getVariable("lighting") or self.light_id < 0 then return end
	self.light.position[1] = self.pos.x + self.light_offset.x
	self.light.position[2] = self.pos.y + self.light_offset.y
end

function Light:setLightRadius(radius)
	self.light.radius = radius
end
