local Consumable = Item:extend("Consumable")

function Consumable:initialize(uses)
	self.uses = uses or 1
end
