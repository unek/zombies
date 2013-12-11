local Entity = Class("game.Entity")

function Entity:initialize(world)
    self._components = {}

    self.world       = assert(world, "world (arg #1) not specified")
    self.id          = self.world:register(self)
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
end

function Entity:destroy()
    for _, component in pairs(self._components) do
        component:destroy()
    end
    self.world:unregister(self)
    self = nil
end

function Entity:hasComponent(name)
    return self._components[name] and true or false
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

return Entity
