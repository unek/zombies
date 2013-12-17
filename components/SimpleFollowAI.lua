local SimpleFollowAI = Component:extend("SimpleFollowAI")

function SimpleFollowAI:initialize(target)
    self.target = target or nil
end

function SimpleFollowAI:update(dt)
    if not self.target or self.target:isDead() then return end
    local target_angle = math.atan2(self.target.pos.y - self.pos.y, self.target.pos.x - self.pos.x)
    self:setRotation(target_angle)
    self:move(math.cos(target_angle), math.sin(target_angle))

    if self:hasComponent("MeleeAttacker") and self:canAttack(self.target) then
        self:attack(self.target)
    end
end

function SimpleFollowAI:setTarget(target)
    self.target = target
end
