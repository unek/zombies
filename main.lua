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
require("components.Rotation")
require("components.Color")
require("components.RenderRectangle")
require("components.RenderCircle")
require("components.ColliderRectangle")
require("components.ColliderCircle")
require("components.Physics")

function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    -- load create the world
    game.world  = World:new("World", 1024, 1024)

    -- testing player
    game.player = Entity:new(game.world)
    game.player:addComponent("Position", 400, 300)
    game.player:addComponent("Rotation")
    game.player:addComponent("Color", 221, 46, 78)
    game.player:addComponent("RenderCircle", 6)
    game.player:addComponent("ColliderCircle")
    game.player:addComponent("Physics", "dynamic")
end

function love.draw()
    game.world:draw()
end

function love.update(dt)
    game.world:update(dt)
end
