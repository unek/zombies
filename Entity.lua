local Entity = Class("game.Entity")

function Entity:initialize(world, components)
    self.world       = assert(world, "world (arg #1) not specified")
    self.id          = self.world:register(self)
    self._components = {}

    if components then
        self:addComponent(components)
    end
end

function Entity:addComponent(components)
    -- if passed a single component as an argument, put it into a table
    local components = type(components) == "string" and {components} or components
    -- now put every component from that table into the entity
    for _, name in ipairs(components) do
        local component = assert(game.component_registry[name], ("component %s not present"):format(name))
        -- mix that component into the entity
        -- this should mix in methods
        for name, method in pairs(component.__instanceDict) do
            if name ~= "initialize" then self[name] = method end
        end
        -- and this should work for variables
        component.initialize(self)
        if component.static then
            for name, method in pairs(component.static) do
                self.static[name] = method
            end
        end
        self._components[name] = component
    end
end

function Entity:hasComponent(name)
    return self._components[name] and true or false
end

function Entity:draw()
    for _, component in pairs(self._components) do
        if component.draw then component:draw() end
    end
end

function Entity:update(dt)
    for _, component in pairs(self._components) do
        if component.update then component:update(dt) end
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
