local Bleeding = Component:extend("Bleeding")

function Bleeding:initialize()
    assert(self:hasComponent("Health"), "Bleeding depends on Health component")
    self.last_bleed = 0
end

function Bleeding:damage(...)
    self:bleed()

    return game.component_registry.Health.damage(self, ...)
end
function Bleeding:bleed()
    local decal = Entity:new(self.world, -1000)
        :addComponent("Transformable", self.pos.x, self.pos.y, math.random(0, math.pi*2))
        :addComponent("FillColor", 255, 255, 255, 200)
        :addComponent("Sprite", game.assets:getImage("blood", true), 50, 50)

    self.world:addDecal(decal)

    return self
end

function Bleeding:update(dt)
    self.last_bleed = self.last_bleed + dt
    if self.health / self.max_health < 0.3 and self.last_bleed > 0.3 then
        self:bleed()
        self.last_bleed = 0
    end
end

