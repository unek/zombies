local Health = Component:extend("Health")

function Health:initialize(health)
	self.max_health = health or 100
	self.health = self.max_health
	self.killer = nil
end

function Health:damage(amount, damager)
	self.health = self.health - amount
	
	if self.health < 0 then
		self:die(damager)
	end

	return self
end

function Health:heal(amount)
	self.health = math.min(self.max_health, self.health + amount)
end

function Health:die(damager)
	self.killer = damager

	self:destroy()

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
