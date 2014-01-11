local MeleeAttacker = Component:extend("MeleeAttacker")

function MeleeAttacker:initialize(reach, power, speed, angle)
    self.attack_angle = angle or math.pi
    self.attack_reach = reach or 15
    self.attack_power = power or 30
    self.attack_speed = speed or 0.9

    self.last_attack  = 0
end

function MeleeAttacker:canAttack(target)
    if self.last_attack + self.attack_speed < love.timer.getTime() then
        -- calculate the maximum distance
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

        -- angle
        local angle = math.atan2(self.pos.y - target.pos.y, self.pos.x - target.pos.x) 
        -- difference
        local diff = angle - self:getRotation()
        diff = diff < 0 and diff + math.pi * 2 or diff

        return diff >= self.attack_angle * .5 and diff <= self.attack_angle * 1.5 and self:getDistanceTo(target) < dist and #self.world:raycast(self, target, 1) == 0
    end

    return false
end

function MeleeAttacker:attack(target)
    local dmg = math.random(self.attack_power * .75, self.attack_power * 1.25)
    target:damage(dmg)

    self.last_attack = love.timer.getTime()
end

return MeleeAttacker
