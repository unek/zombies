-- important stuff
Class = require("libraries.middleclass")

-- this stuff is also important
Entity    = require("Entity")
Component = require("Component")

-- creates the game, the rest of the code isn't important
game = {}

-- registries
game.component_registry = {}
-- factories

-- basic components
require("components.Position")

function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    -- hello world!
    print("The game loaded")
    print("And that's nice")
    print("Oh indeed it is")

    -- testing entity
    local player = Entity:new()
    player:addComponent("Position")

    print(("%s position: %dx%d"):format(tostring(player), player:getPosition()))
end
