-- important stuff
Class = require("libraries.middleclass")

-- this stuff is also important
Entity    = require("Entity")
Component = require("Component")

World     = require("World")

-- creates the game, the rest of the code isn't important
game        = {}
game.world  = nil -- holds current world
game.player = nil -- player's entity

-- registries
game.component_registry = {}
-- factories

-- basic components
require("components.Position")
require("components.Color")
require("components.RenderBox")
require("components.RenderCircle")
require("components.CollisionCircle")
require("components.Physics")

function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    -- load create the world
    game.world   = World:new("World", 1024, 1024)

    -- testing player
    game.player = Entity:new(game.world)
    game.player:addComponent({"Position", "Color", "RenderCircle", "CollisionCircle", "Physics"})
    game.player:setPosition(90, 90):setRadius(6):setColor(221, 46, 78)
end

function love.draw()
    game.world:draw()
end

function love.update(dt)
    game.world:update(dt)
end
