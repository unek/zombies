local HealthIndicator = Component:extend("HealthIndicator")

function HealthIndicator:initialize(radius)
    self.indicator_radius = radius or self.radius + 5

    -- for tweening
    self._prev_health = self.health
    self._indicator   = self.health / self.max_health
end

function HealthIndicator:draw()
    local color    = self._indicator * 255
    local vertices = {}
    local segments = 40

    for i = 0, math.floor(self._indicator * segments) do
        local theta = (i / segments) * math.pi * 2
        table.insert(vertices, self.pos.x + math.cos(theta) * self.indicator_radius)
        table.insert(vertices, self.pos.y + math.sin(theta) * self.indicator_radius)
    end

    love.graphics.setColor(255 - color, color, 255, 200)
    love.graphics.setLineWidth(3)
    if #vertices >= 4 then
        love.graphics.line(unpack(vertices))
    end
    
    love.graphics.setLineWidth(1)
end

function HealthIndicator:update(dt)
    -- do the linear tweening
    if self._prev_health ~= self.health then
        Timer.tween(0.3, self, {_indicator = (self.health / self.max_health)})
    end

    self._prev_health = self.health
end

return HealthIndicator
