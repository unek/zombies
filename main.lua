-- important stuff
Class = require("libraries.middleclass")

-- this stuff is also important
Entity    = require("Entity")
Component = require("Component")

World     = require("World")

-- creates the game, the rest of the code isn't important
game       = {}
game.world = nil -- holds current world
--(not)

-- registries
game.component_registry = {}
-- factories

-- basic components
require("components.Position")
require("components.Box")

function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    -- hello world!
    print("The game loaded")
    print("And that's nice")
    print("Oh indeed it is")

    -- testing entity
    game.world   = World:new("World", 1024, 1024)
    local player = Entity:new(game.world)
    player:addComponent("Position")
    player:addComponent("Box")
    player:setPosition(90, 90):setSize(50, 50)
end

function love.draw()
    game.world:draw()
end

function love.update(dt)
    game.world:update(dt)
end
