hud          = {}
hud.registry = {}
hud.objects  = {}
hud.debug    = true
hud.hover    = false
hud.current  = false

local path = ...
require(path .. ".Object")
require(path .. ".Button")

hud.objects.base = hud.registry.Object:new(nil, 0, 0, love.window.getDimensions())
hud.objects.base:setPadding(15)

function hud.draw()
    for _, object in pairs(hud.objects) do
        object:draw()

        -- draw bounding box
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
    hud.hover    = false
    for _, object in pairs(hud.objects) do
        object:update(dt)

        if mx >= object.pos.x and mx <= object.pos.x + object.width and
            my >= object.pos.y and my <= object.pos.y + object.height then
            hud.hover = object
        end
    end
end

function hud.mousepressed(x, y, button)
    for _, object in pairs(hud.objects) do
        if object.mousepressed and object:isHovered() then
            object:mousepressed(x, y, button)
        end
    end

    return hud.hover and true
end

function hud.mousereleased(x, y, button)
    for _, object in pairs(hud.objects) do
        if object.mousereleased and object:isHovered() then
            object:mousereleased(x, y, button)
        end
    end

    return hud.hover and true
end
