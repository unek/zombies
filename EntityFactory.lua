local EntityFactory = Class("game.EntityFactory")

function EntityFactory:initialize()
    self.components = {}
end

function EntityFactory:addComponent(name, ...)
    table.insert(self.components, {name, ...})

    return self
end

function EntityFactory:spawn(...)
    local entity = Entity:new(...)
    for name, component in pairs(self.components) do
        entity:addComponent(unpack(component))
    end

    return entity
end

return EntityFactory