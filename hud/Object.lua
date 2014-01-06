local Object = Class("hud.Object")
hud.registry.Object = Object

-- todo: geometry support
function Object:initialize(parent, x, y, w, h)
    self.parent = parent or hud.objects.base

    self.pos    = {}
    self.pos.x  = x or self.parent.padding.x
    self.pos.y  = y or self.parent.padding.y

    self.width  = w or self.parent.width - self.parent.padding.x * 2
    self.height = h or self.parent.height - self.parent.padding.y * 2

    self.padding   = {}
    self.padding.x = 0
    self.padding.y = 0

    self._callbacks = {}
end

function Object:extend(name)
    local class = Class("hud." .. name, Object)
    hud.registry[name] = class

    return class
end

function Object:draw()

end

function Object:update(dt)

end

function Object:setPadding(x, y)
    self.padding.x, self.padding.y = x, y or x

    return self
end

function Object:setSize(w, h)
    self.width, self.height = w, h or w

    return self
end

function Object:setWidth(w)
    self.width = w

    return self
end

function Object:setHeight(h)
    self.height = h

    return self
end

function Object:centerX()
    self.pos.x = self.parent.padding.x + (self.parent.width - self.width) / 2

    return self
end

function Object:centerY()
    self.pos.y = self.parent.padding.y + (self.parent.height - self.height) / 2

    return self
end

function Object:center()
    return self:centerX():centerY()
end

function Object:isHovered()
    return hud.hover == self
end

function Object:emit(event, ...)
    for _, callback in pairs(self._callbacks) do
        if callback.event == event then
            if callback.func(self, ...) then
                return true
            end
        end
    end

    return false
end

function Object:on(event, func)
    local callback = {}
    callback.event = event
    callback.func  = func
    table.insert(self._callbacks, callback)

    return self
end