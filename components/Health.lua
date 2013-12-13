local Health = Component:extend("Health")

function Health:initialize(health)
	self.health = health or 100
	self.killer = nil
end

function Health:damage(amount, damager)
	self.health = self.health - amount
	if self.health < 0 then
		self:die(damager)
	end

	return self
end

function Health:die(damager)
	self.killer = damager

	return self
end

function Health:setHealth(health)
	self.health = health

	return self
end

function Health:getHealth()
	return self.health
end

function Health:isAlive()
	return self.health > 0
end

function Health:isDead()
	return not self:isAlive()
end
