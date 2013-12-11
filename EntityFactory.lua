local EntityFactory = Class("game.EntityFactory")

function EntityFactory:initialize()
    self.components = {}
end

function EntityFactory:addComponent(name, ...)
    self.components[name] = {...}
end

function EntityFactory:spawn(...)
    local entity = Entity:new(...)
    for name, component in ipairs(self.components) do
        entity:addComponent(name, unpack(component))
    end

    return Entity
end

return EntityFactory