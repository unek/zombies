-- important stuff
Class = require("libraries.middleclass")

-- this stuff is also important
Entity        = require("Entity")
Component     = require("Component")
EntityFactory = require("EntityFactory")

World     = require("World")
Camera    = require("Camera")

Console      = require("Console")
InputManager = require("InputManager")


-- settings system?
Config = require("Config")

-- creates the game, the rest of the code isn't important
game = {}

-- registries
game.component_registry = {}

-- basic components
require("components")

function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    -- load config
    game.config = {}
    Config:read(game.config)

    -- temporairly disabled lighting
    game.config.lighting = false

    -- load create the world
    game.world   = World:new("World", 1024, 1024, "test/canvas.png", "test/normals.png")

    -- the camera
    game.camera  = Camera:new()

    -- input management
    game.input   = InputManager:new()

    -- console
    game.console = Console:new()

    game.console:registerCommand("bind", function(argv)
        local action = assert(argv[1], "no action (arg #1) specified")
        local key    = assert(argv[2], "no key/button (arg #2) specified")

        game.input:register(action, key)
        return true, ("bound %q to %q"):format(action, key)
    end)

    -- testing player
    game.player = Entity:new(game.world)
        :addComponent("Transformable", 400, 300)
        :addComponent("AnimatedSprite", love.graphics.newImage("assets/player.png"), 132, 140, 1, 6)
        :addComponent("ColliderCircle", 6)
        :addComponent("Physics", "dynamic")
        :addComponent("Movement")
        :addComponent("Light", { 255, 0, 255 }, 150, 1.8)

    game.crate_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", love.graphics.newImage("assets/metal_crate.png"), 128, 128)
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "dynamic")

    game.container_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", love.graphics.newImage("assets/container.png"))
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "static")

    game.tree_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", love.graphics.newImage("assets/tree3.png"))
        :addComponent("ColliderCircle", 6)
        :addComponent("Physics", "static")

    game.zombie_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Color", 255, 0, 0)
        :addComponent("RenderCircle", 6)
        :addComponent("ColliderCircle")
        :addComponent("Physics", "dynamic")
        :addComponent("Movement", 150)
        :addComponent("SimpleFollowAI", game.player)
        :addComponent("Light", { 255, 0, 255 }, 150, 1.8)

    game.crate_factory:spawn(game.world):setPosition(400, 100):setRotation(math.pi / 5)
    game.tree_factory:spawn(game.world):setPosition(220, 350)

    -- register some keys
    game.input:register("move left", "a", "left")
    game.input:register("move right", "d", "right")
    game.input:register("move up", "w", "up")
    game.input:register("move down", "s", "down")

    game.input:register("spawn horde", "h")

    -- and some buttons
    game.input:register("spawn horde", "mouse l")

    -- make the camera follow the player
    game.camera:follow(game.player)
end

function love.draw()
    game.camera:push()
        game.world:draw()
    game.camera:pop()

    love.graphics.setColor(255, 255, 255)
    love.graphics.print(love.timer.getFPS(), 30, 30)
    love.graphics.print(game.world.world:getBodyCount(), 30, 50)
end

function love.update(dt)
    -- update world and its entities
    game.world:update(dt)

    -- movement part
    local left   = game.input:isDown("move left")
    local right  = game.input:isDown("move right")
    local up     = game.input:isDown("move up")
    local down   = game.input:isDown("move down")
    local mx, my = 0, 0

    if left and not right then mx = -1
    elseif right and not left then mx = 1 end

    if up and not down then my = -1
    elseif down and not up then my = 1 end

    game.player:move(mx, my)

    -- make player look at the mouse
    local x, y = game.camera:getMousePosition()
    game.player:setRotation(-math.atan2(game.player.pos.x - x, game.player.pos.y - y))

    if game.input:justReleased("spawn horde") then
        for i = 1, 5 do
            local x, y = game.camera:getMousePosition()
            game.zombie_factory:spawn(game.world, 10):setPosition(x, y + i)
        end
    end

    -- update input
    game.input:update(dt)
end

function love.mousepressed(x, y, button)
    if button == "r" then
        game.tree_factory:spawn(game.world, 200)
            :setPosition(game.camera:getMousePosition())
            :setRotation(-math.pi, math.pi)
            :setImage(love.graphics.newImage("assets/tree"..math.random(3,9)..".png"))
    elseif button == "wu" then
        local size = 32 + 96 + math.sin(love.timer.getTime() * 10) * 96

        game.crate_factory:spawn(game.world, 10)
            :setPosition(game.camera:getMousePosition())
            :setRotation(math.pi / math.random(2, 5))
            :setSize(size, size)
            :setColliderSize(size, size)
    end

    game.input:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    game.input:mousereleased(x, y, button)
end

function love.keypressed(key)
    game.input:keypressed(key)
end

function love.keyreleased(key)
    game.input:keyreleased(key)
end

function love.quit()
    Config:save(game.config)
end
