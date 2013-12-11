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
    game.player:addComponent("Color", 221, 46, 78)
    game.player:addComponent("RenderCircle", 6)
    game.player:addComponent("ColliderCircle")
    game.player:addComponent("Physics", "dynamic")

    -- a crate
    local crate = Entity:new(game.world)
    crate:addComponent("Position", 600, 300)
    crate:addComponent("Color", 39, 178, 21)
    crate:addComponent("RenderRectangle", 25, 25)
    crate:addComponent("ColliderRectangle")
    crate:addComponent("Physics", "dynamic")
end

function love.draw()
    game.world:draw()
end

function love.update(dt)
    game.world:update(dt)
end
