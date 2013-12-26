local Camera = Class("Camera")
local min, max = math.min, math.max
function Camera:initialize(x, y)
    self.pos   = {}
    self.pos.x = x or 0
    self.pos.y = y or 0

    self.target = nil
end
function Camera:lookAt(x, y)
    self.pos.x = x
    self.pos.y = y
end
function Camera:follow(entity)
    self.target = entity
end
function Camera:push()
    local w, h   = love.graphics.getDimensions()
    local ww, wh = self.target.world:getSize()

    if self.target then
        local x, y = self.target:getPosition()
        if ww > w and wh > h then
            self.pos.x = min(max(x, w / 2), ww - w / 2)
            self.pos.y = min(max(y, h / 2), wh - h / 2)
        else
            self.pos.x, self.pos.y = x, y
        end
    end

    love.graphics.push()
    love.graphics.translate(w / 2, h / 2)
    love.graphics.translate(-self.pos.x, -self.pos.y)
end

function Camera:pop()
    love.graphics.pop()
end
function Camera:getMousePosition()
    return self:toWorld(love.mouse.getPosition())
end
function Camera:toCamera(x, y)
    local w, h = love.graphics.getDimensions()
    local x = x - self.pos.x + w / 2
    local y = y - self.pos.y + h / 2

    return x, y
end
function Camera:toWorld(x, y)
    local w, h = love.graphics.getDimensions()
    local x = x - w / 2
    local y = y - h / 2

    return x + self.pos.x, y + self.pos.y
end
function Camera:getBounds()
    local w, h = love.graphics.getDimensions()
    local x, y = self.pos.x, self.pos.y
    return x - w / 2, y - h / 2 , x + w / 2, y + h / 2
end

return Camera
