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
game.debug  = true

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
        :addComponent("Movement")

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

local function xor(a, b) return (a or b) and not (a and b) end
function love.update(dt)
    game.world:update(dt)

    local left  = love.keyboard.isDown("a")
    local right = love.keyboard.isDown("d")
    local up    = love.keyboard.isDown("w")
    local down  = love.keyboard.isDown("s")
    local mx    = 0
    local my    = 0

    if left and not right then mx = -1
    elseif right and not left then mx = 1 end

    if up and not down then my = -1
    elseif down and not up then my = 1 end

    game.player:move(mx, my)
end
