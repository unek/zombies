local MeleeAttacker = Component:extend("MeleeAttacker")

function MeleeAttacker:initialize(reach, power, speed)
    self.attack_reach = reach or 15
    self.attack_power = power or 30
    self.attack_speed = speed or 0.9

    self.last_attack  = 0
end

function MeleeAttacker:canAttack(target)
    if self.last_attack + self.attack_speed < love.timer.getTime() then
        local dist = self.attack_reach
        if target:hasComponent("ColliderCircle") then
            dist = dist + target.physics_shape:getRadius()
        elseif target:hasComponent("ColliderRectangle") then
            dist = dist + math.max(target.physics_width, target.physics_height) / 2
        end

        if self:hasComponent("ColliderCircle") then
            dist = dist + self.physics_shape:getRadius()
        elseif self:hasComponent("ColliderRectangle") then
            dist = dist + math.max(self.physics_width, self.physics_height) / 2
        end

        return self:getDistanceTo(target) < dist and #self.world:getPathIntersections(self, target) == 0
    end

    return false
end

function MeleeAttacker:attack(target)
    local dmg = math.random(self.attack_power * 3/4, self.attack_power * 5/4)
    target:damage(dmg)

    self.last_attack = love.timer.getTime()
end

return MeleeAttacker
