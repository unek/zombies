local SimpleFollowAI = Component:extend("SimpleFollowAI")

function SimpleFollowAI:initialize(target)
    self.target = target or nil
end

function SimpleFollowAI:update(dt)
    if not self.target then return end
    local target_angle = math.atan2(game.player.pos.x - self.pos.x, game.player.pos.y - self.pos.y)
    self:move(math.sin(target_angle), math.cos(target_angle))
end

function SimpleFollowAI:setTarget(target)
    self.target = target
end