local Pickup = Component:extend("Pickup")

function Pickup:initialize(count, item_name, ...)
	self.pickup_radius     = 30
	self.pickup_item       = assert(game.item_registry[item_name]:new(...), "item not existing")
	self.pickup_count      = count or 32
	self.pickup_properties = properties or {}
end

function Pickup:update(dt)
	for _, entity in pairs(self.world.entities) do
		if entity:hasComponent("Inventory") and entity:getDistanceTo(self) <= self.pickup_radius then
			local success, left = entity:giveItem(self.pickup_item, self.pickup_count, self.pickup_properties)

			if success then
				self:destroy()
			else
				self.pickup_count = left
			end

			return
		end
	end
end

function Pickup:draw()
	-- outline
	love.graphics.setLineWidth(2)
	love.graphics.setColor(0, 180, 255)
	love.graphics.circle("line", self.pos.x, self.pos.y, self.pickup_radius)

	-- label
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("x" .. self.pickup_count, self.pos.x + self.pickup_radius * 3/4, self.pos.y + self.pickup_radius * 3/4)
	-- item sprite
	if self.pickup_item.draw then
		self.pickup_item:draw(self.pos.x, self.pos.y)
	end
end
