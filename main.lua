-- important stuff
Class = require("libraries.middleclass")

-- this stuff is also important
Entity    = require("Entity")
Component = require("Component")

World     = require("World")
Camera    = require("Camera")

EntityFactory = require("EntityFactory")

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
    game.world  = World:new("World", 1024, 1024, "test/canvas.png", "test/normals.png")

    -- the camera
    game.camera = Camera:new()

    -- testing player
    game.player = Entity:new(game.world)
        :addComponent("Position", 400, 300)
        :addComponent("Rotation")
        :addComponent("Color", 255, 255, 0)
        :addComponent("RenderCircle", 6)
        :addComponent("ColliderCircle")
        :addComponent("Physics", "dynamic")
        :addComponent("Movement")
        :addComponent("Light", { 255, 0, 255 }, 150, 1.8)

    game.crate_factory = EntityFactory:new()
        :addComponent("Position")
        :addComponent("Rotation")
        :addComponent("Sprite", love.graphics.newImage("assets/metal_crate.png"), 128, 128)
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "dynamic")

    game.container_factory = EntityFactory:new()
        :addComponent("Position")
        :addComponent("Rotation")
        :addComponent("Sprite", love.graphics.newImage("assets/container.png"))
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "static")

    game.tree_factory = EntityFactory:new()
        :addComponent("Position")
        :addComponent("Rotation")
        :addComponent("Sprite", love.graphics.newImage("assets/tree3.png"))
        :addComponent("ColliderCircle", 6)
        :addComponent("Physics", "static")

    game.crate_factory:spawn(game.world):setPosition(400, 100):setRotation(math.pi / 5)
    game.tree_factory:spawn(game.world):setPosition(220, 350)
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
    game.world:update(dt)

    local left  = love.keyboard.isDown("a") or love.keyboard.isDown("left")
    local right = love.keyboard.isDown("d") or love.keyboard.isDown("right")
    local up    = love.keyboard.isDown("w") or love.keyboard.isDown("up")
    local down  = love.keyboard.isDown("s") or love.keyboard.isDown("down")
    local mx    = 0
    local my    = 0

    if left and not right then mx = -1
    elseif right and not left then mx = 1 end

    if up and not down then my = -1
    elseif down and not up then my = 1 end

    game.player:move(mx, my)

    local cx, cy = game.player:getPosition()
    cx = math.min(math.max(cx, love.graphics.getWidth() / 2), game.world.width + love.graphics.getWidth() / 2)
    cy = math.min(math.max(cy, love.graphics.getHeight() / 2), game.world.height + love.graphics.getHeight() / 2)
    game.camera:lookAt(cx, cy)
end

function love.mousepressed(x, y, button)
    if button == "r" then
        game.tree_factory:spawn(game.world)
            :setPosition(game.camera:mousePosition())
            :setRotation(-math.pi, math.pi)
            :setImage(love.graphics.newImage("assets/tree"..math.random(3,9)..".png"))
    else
        local size = 32 + 96 + math.sin(love.timer.getTime() * 10) * 96

        game.crate_factory:spawn(game.world)
            :setPosition(game.camera:mousePosition())
            :setRotation(math.pi / math.random(2, 5))
            :setSize(size, size)
            :setColliderSize(size, size)
    end
end

function love.quit()
	Config:save(game.config)
end
