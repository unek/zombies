-- some basic objects
Entity        = require("Entity")
Component     = require("Component")
EntityFactory = require("EntityFactory")

World  = require("World")
Camera = require("Camera")

InputManager = require("InputManager")

Timer = require("libraries.timer")

-- this creates the game, the rest isn't really important
game = {}

-- registries
game.component_registry = {}

-- require basic components
require("components")

function game:init()
    -- input management
    game.input   = InputManager:new()

    -- the camera
    game.camera  = Camera:new()

    -- load create the world
    game.world   = World:new("World", 1024, 1024, "test/canvas.png", "test/normals.png")

    -- testing player
    game.player = Entity:new(game.world)
        :addComponent("Transformable", 400, 300)
        :addComponent("Color", 190, 43, 43)
        :addComponent("RenderCircle", 9)
        :addComponent("ColliderCircle")
        :addComponent("Physics", "dynamic", 0.37)
        :addComponent("Movement")
        :addComponent("Health", 10000)
        :addComponent("HealthIndicator")

    game.crate_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", game.assets:getImage("metal_crate"), 128, 128)
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "dynamic", 100)

    game.container_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", game.assets:getImage("container"))
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "static")

    game.tree_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", game.assets:getImage("tree3"))
        :addComponent("ColliderCircle", 6)
        :addComponent("Physics", "static")

    game.zombie_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Color", 43, 190, 43)
        :addComponent("RenderCircle", 9)
        :addComponent("ColliderCircle")
        :addComponent("Physics", "dynamic", 0.37)
        :addComponent("Movement", 150)
        :addComponent("Health", 150)
        :addComponent("SimpleFollowAI", game.player)
        :addComponent("HealthIndicator")
        :addComponent("MeleeAttacker")

    game.crate_factory:spawn(game.world, 100):setPosition(400, 100):setRotation(math.pi / 5)
    game.tree_factory:spawn(game.world, 200):setPosition(220, 350)

    -- register some keys
    game.input:register("move left", "a", "left")
    game.input:register("move right", "d", "right")
    game.input:register("move up", "w", "up")
    game.input:register("move down", "s", "down")

    game.input:register("spawn horde", "h")

    -- and some buttons
    game.input:register("spawn horde", "mouse right")
    game.input:register("spawn explosion", "mouse middle")

    -- make the camera follow the player
    game.camera:follow(game.player)
end


function game:draw()
    game.camera:push()
        game.world:draw()
    game.camera:pop()

    love.graphics.setColor(255, 255, 255)
    love.graphics.print(love.timer.getFPS(), 30, 30)
    love.graphics.print(game.world.world:getBodyCount(), 30, 50)
    love.graphics.print(game.player:getHealth(), 30, 80)
end

function game:update(dt)
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
    game.player:setRotation(math.atan2(y - game.player.pos.y, x - game.player.pos.x))

    if game.input:justReleased("spawn horde") then
        for i = -150, 150, 50 do
            local x, y = game.camera:getMousePosition()
            game.zombie_factory:spawn(game.world, 1):setPosition(x, y + i)
        end
    end
    if game.input:justReleased("spawn explosion") then
        local x, y = game.camera:getMousePosition()
        game.world:explode(x, y, 1000)
    end

    Timer.update(dt)

    -- update input
    game.input:update(dt)
end

function game:mousepressed(x, y, button)
    game.input:mousepressed(x, y, button)
end

function game:mousereleased(x, y, button)
    game.input:mousereleased(x, y, button)
end

function game:keypressed(key)
    game.input:keypressed(key)
end

function game:keyreleased(key)
    game.input:keyreleased(key)
end
