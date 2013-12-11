-- important stuff
Class = require("libraries.middleclass")

-- this stuff is also important
Entity    = require("Entity")
Component = require("Component")

World     = require("World")

EntityFactory = require("EntityFactory")

-- creates the game, the rest of the code isn't important
game        = {}
game.world  = nil -- holds current world
game.player = nil -- player's entity

-- registries
game.component_registry = {}

-- factories
game.crate_factory = EntityFactory:new()

-- basic components
require("components")

function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    -- load create the world
    game.world  = World:new("World", 1024, 1024)

    -- testing player
    game.player = Entity:new(game.world)
        :addComponent("Position", 400, 300)
        :addComponent("Rotation")
        :addComponent("Color", 255, 0, 0)
        :addComponent("RenderCircle", 6)
        :addComponent("ColliderCircle")
        :addComponent("Physics", "dynamic")

    game.crate_factory
        :addComponent("Position")
        :addComponent("Rotation")
        :addComponent("Sprite", love.graphics.newImage("assets/metal_crate.png"), 128, 128)
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "dynamic")

    game.crate_factory:spawn(game.world):setPosition(400, 100)
end

function love.draw()
    game.world:draw()
end

function love.update(dt)
    game.world:update(dt)

    if love.keyboard.isDown("w") then
        game.player.physics_body:applyForce(0, -200)
    elseif love.keyboard.isDown("s") then
        game.player.physics_body:applyForce(0,  200)
    end
    if love.keyboard.isDown("a") then
        game.player.physics_body:applyForce(-200, 0)
    elseif love.keyboard.isDown("d") then
        game.player.physics_body:applyForce(200 , 0)
    end
end

function love.mousepressed(x, y, button)
    local size = 2^5
    if button == "r" then
        size = 2^math.random(5, 7)
    end
    game.crate_factory
        :spawn(game.world)
        :setPosition(x, y)
        :setRotation(math.random(0, math.pi*2))
        :setSize(size, size)
        :setColliderSize(size, size)
end