hud          = {}
hud.registry = {}
hud.objects  = {}
hud.debug    = true
hud.hover    = false

local path = ...
require(path .. ".Object")
require(path .. ".Button")

function hud.load()
    hud.objects.base = hud.registry.Object:new(nil, 0, 0, love.graphics.getDimensions())
    hud.objects.base:setPadding(15)
end

function hud.draw()
    for _, object in pairs(hud.objects) do
        object:draw()

        if hud.debug then
            love.graphics.setColor(255, 127, 0)
            love.graphics.setLineWidth(3)
            love.graphics.rectangle("line", object.pos.x, object.pos.y, object.width, object.height)
        end
    end
end

function hud.spawn(name, ...)
    local object = hud.registry[name]:new(...)
    table.insert(hud.objects, object)

    return object
end

function hud.update(dt)
    local mx, my = love.mouse.getPosition()
    for _, object in pairs(hud.objects) do
        object:update(dt)

        if mx >= object.pos.x and mx <= object.pos.x + object.width and
            my >= object.pos.y and my <= object.pos.y + object.height then
            hud.hover = object
        end
    end
end

local callbacks = {"keypressed", "keyreleased", "mousepressed", "mousereleased"}

for _, callback in pairs(callbacks) do
    hud[callback] = function(...)
        for _, object in pairs(hud.objects) do
            if object[callback] then object[callback](object, ...) end
        end
    end
end
