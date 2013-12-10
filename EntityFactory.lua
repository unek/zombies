local EntityFactory = Class("game.EntityFactory")

function EntityFactory:initialize(components)
    self._components = type(components) == "string" and {components} or components
end

function EntityFactory:spawn()
    local entity = Entity()
    for _, component in ipairs(self._components) do
        entity:addComponent(component)
    end

    return Entity
end

return EntityFactory