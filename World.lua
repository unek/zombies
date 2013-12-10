local World = Class("game.World")

function World:initialize(title, width, height)
    self.title  = title  or "World"

    self.width  = width  or 1024
    self.height = height or 1024

    self.entities = {}
    self._last_id = 0
end

function World:register(entity)
    self._last_id = self._last_id + 1
    local id      = self._last_id

    self.entities[id] = entity

    return id
end

function World:draw()
    for _, entity in pairs(self.entities) do
        entity:draw()
    end
end

function World:update(dt)
    for _, entity in pairs(self.entities) do
        entity:update(dt)
    end
end


return World
