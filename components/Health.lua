local Health = Component:extend("Health")

function Health:initialize(health)
    self.max_health = health or 100
    self.health = self.max_health
end

function Health:damage(amount, damager)
    local event = self:emit("damage", amount, damager) or (damager and damager:emit("hit", amount, self))
    -- events (or more like callbacks.. maybe?) can return true to cancel
    if event then return self end

    self.health = self.health - amount
    
    if self.health < 0 then
        self:die(damager)
    end

    return self
end

function Health:heal(amount)
    local event = self:emit("heal", amount)
    if event then return self end

    self.health = math.min(self.max_health, self.health + amount)

    return self
end

function Health:die(killer)
    local event = self:emit("death", killer)
    if event then return self end

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
