local Entity = Class("game.Entity")

function Entity:initialize(world, z)
    self._components = {}
    self._callbacks  = {}
    self._flags      = {}

    self.world       = assert(world, "world (arg #1) not specified")
    self.id          = self.world:register(self, z)
end

function Entity:addComponent(name, ...)
    -- instantiate the components and put it into the entity
    local component = assert(game.component_registry[name], ("component %s not present"):format(name))
    -- mix that component into the entity
    -- this should mix in methods
    for name, method in pairs(component.__instanceDict) do
        if Entity[name] == nil then self[name] = method end
    end
    -- and this should work for variables
    component.initialize(self, ...)
    self._components[name] = component

    return self
end

function Entity:hasComponent(name)
    return self._components[name] and true or false
end

function Entity:setFlag(flag, value)
    self._flags[flag] = value

    return self
end

function Entity:getFlag(flag)
    return self._flags[flag]
end
function Entity:destroy()
    for _, component in pairs(self._components) do
        component.destroy(self)
    end
    self.world:unregister(self)
end

function Entity:draw()
    for _, component in pairs(self._components) do
        if component.draw then component.draw(self) end
    end
end

function Entity:update(dt)
    for _, component in pairs(self._components) do
        if component.update then component.update(self, dt) end
    end
end

function Entity:__tostring()
    local components = {}
    for name in pairs(self._components) do
        table.insert(components, name)
    end

    return ("Entity #%d (components: %s)"):format(self.id, table.concat(components, ", "))
end

function Entity:emit(event, ...)
    for _, callback in pairs(self._callbacks) do
        if callback.event == event then
            if callback.func(self, ...) then
                return true
            end
        end
    end

    return false
end

function Entity:on(event, func)
    local callback = {}
    callback.event = event
    callback.func  = func
    table.insert(self._callbacks, callback)

    return self
end

return Entity
