local Component = Class("game.Component")

function Component:initialize()
    
end

function Component:destroy()

end

function Component:extend(name)
    local name      = assert(name, "components name not specified")
    -- extend the current component
    local component = Class("game.components."..name, self)

    -- register it
    game.component_registry[name] = component

    return component
end

return Component
