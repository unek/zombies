local Explosive = Component:extend("Explosive")

function Explosive:initialize(power)
    assert(self:hasComponent("Health"), "Explosive depends on Health component")
    self.explosion_power = power or 1000
end

function Explosive:die(...)
    -- all of this just because we can't update the world inside a callback.
    -- and an explosions calls a callback. and if an explosive gets destroyed with an explosion, exactly this happens.
    local world = self.world
    local x, y  = self:getPosition()
    local power = self.explosion_power
    local owner = self.owner or self

    Timer.add(0, function()
        world:explode(x, y, power, owner)
    end)

    return game.component_registry.Health.die(self, ...)
end
