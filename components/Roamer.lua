local Roamer = Component:extend("Roamer")

function Roamer:initialize()
    self.roam_vector   = {}
    self.roam_vector.x = 0
    self.roam_vector.y = 0

    self._last_roam_move = 0
end

function Roamer:update(dt)
    self._last_roam_move = self._last_roam_move + dt
    if self._last_roam_move > 2 then
        self:_findMove()
        self._last_roam_move = 0
    end

    self:move(self.roam_vector.x, self.roam_vector.y)
end

function Roamer:_findMove()
    self.roam_vector.x = self.roam_vector.y + (love.math.random() * 2 - 1) * 0.2
    self.roam_vector.y = self.roam_vector.y + (love.math.random() * 2 - 1) * 0.2
end
