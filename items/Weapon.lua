local Weapon = Item:extend("Weapon")

Weapon.static.MAX_STACK = 2

function Weapon:initialize(damage_bonus)
	self.name         = "Weapon"
	self.damage_bonus = damage_bonus or 0
end

