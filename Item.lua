local Item = Class("game.Item")

Item.static.MAX_STACK = 16

function Item:initialize(weight)
	self.name   = "Item"
	self.weight = weight or 100
end

function Item:extend(name)
	local class = Class("game.items." .. name, Item)
	game.item_registry[name] = class
	return class
end

return Item
