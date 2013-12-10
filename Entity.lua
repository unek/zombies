local Entity = Class("game.Entity")

function Entity:initialize(components)
    self.id          = 0
    self._components = {}
end

function Entity:addComponent(components)
    -- if passed a single component as an argument, put it into a table
    local components = type(components) == "string" and {components} or components
    -- now put every component from that table into the entity
    for _, name in ipairs(components) do
        local component = assert(game.component_registry[name], ("component %s not present"):format(name))
        -- mix that component into the entity
        self:include(component)
        self._components[name] = component
    end
end

function Entity:hasComponent(name)
    return self._components[name] and true or false
end

function Entity:__tostring()
    local components = {}
    for name in pairs(self._components) do
        table.insert(components, name)
    end

    return ("Entity #%d (components: %s)"):format(self.id, table.concat(components, ", "))
end

return Entity
