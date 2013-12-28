-- some basic objects
Entity        = require("Entity")
Component     = require("Component")
EntityFactory = require("EntityFactory")

Item = require("Item")

World  = require("World")
Camera = require("Camera")

InputManager = require("InputManager")

Timer = require("libraries.timer")

-- this creates the game, the rest isn't really important
game = {}

-- registries
game.component_registry = {}
game.item_registry      = {}

-- require basic components
require("components")
require("items")

function game:init()
    -- the camera
    game.camera  = Camera:new()

    -- load create the world
    game.world   = World:new("World", 2048, 2048, game.assets:getImage("terrain"))

    -- testing player
    game.player  = Entity:new(game.world)
        :addComponent("Transformable", 400, 300)
        :addComponent("Health", 200)
        :addComponent("HealthIndicator", 15)
        :addComponent("Bleeding")
        :addComponent("Color", 190, 43, 43)
        :addComponent("RenderCircle", 9)
        :addComponent("ColliderCircle")
        :addComponent("Physics", "dynamic", 0.37)
        :addComponent("Movement", 200)
        :addComponent("Inventory", 4)

    game.crate_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", game.assets:getImage("metal_crate"), 128, 128)
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "dynamic", 100)
        :addComponent("Health", 50)
        :addComponent("Explosive", 1000)

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
        :addComponent("Health", 100)
        :addComponent("Bleeding")
        :addComponent("SimpleFollowAI", game.player)
        :addComponent("HealthIndicator")
        :addComponent("MeleeAttacker")

    game.crate_factory:spawn(game.world, 100):setPosition(400, 100):setRotation(math.pi / 5)
    game.tree_factory:spawn(game.world, 200):setPosition(220, 350)

    game.world:spawnPickup(250, 250, "Medkit", 1)
    game.world:spawnPickup(200, 250, "Medkit", 1)
    game.world:spawnPickup(250, 300, "Medkit", 1)
    game.world:spawnPickup(250, 350, "Medkit", 1)
    game.world:spawnPickup(200, 300, "Medkit", 1)
    game.world:spawnPickup(200, 350, "Medkit", 1)
    game.world:spawnPickup(250, 450, "MachineGun", 1)

    -- make the camera follow the player
    game.camera:follow(game.player)

    game.player:on("death", function(entity, killer)
        Gamestate.push(gameover)

        -- refuse to destroy the player entity
        -- it seems to screw up some things.
        -- todo: fix those things
        return true
    end)
end


function game:draw()
    game.camera:push()
        game.world:draw()
    game.camera:pop()

    -- todo: move it to some kind of hud lib
    local w, h = love.window.getDimensions()
    local bold_font  = game.assets:getFont("Roboto-Bold")
    local huge_font  = game.assets:getFont("Roboto-Black")
    for i = 1, game.player.inv_size do
        local size = 42
        local x, y = w - (size + 8), h - (game.player.inv_size - i + 1) * (size + 8)

        -- draw indicators
        if game.player.inv_selected == i then
            love.graphics.setColor(0, 180, 255)
        else
            love.graphics.setColor(60, 60, 60, 170)
        end

        love.graphics.rectangle("fill", x + size, y, 3, size)

        local item = game.player.inv_items[i]
        if item then
            -- draw the item sprite
            item:draw(x + size / 2, y + size / 2, size)

            -- print the item count
            if item.amount > 1 then
                local label = "x" .. item.amount
                local w     = bold_font[15]:getWidth(label)
                local h     = bold_font[15]:getHeight(label)

                love.graphics.setFont(bold_font[15])
                love.graphics.setColor(255, 255, 255)
                love.graphics.print(label, x + size - w, y + size - h)
            end
        else
        -- draw the big numbers
            love.graphics.setFont(huge_font[35])
            love.graphics.setColor(255, 255, 255, 120)
            love.graphics.print(i, x + size - huge_font[35]:getWidth(i) - size / 4, y + (size - huge_font[35]:getHeight()) / 2)
        end
    end

    -- debug stuff
    love.graphics.setFont(game.assets:getFont("Roboto-Regular")[12])
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(love.timer.getFPS(), 30, 30)
    love.graphics.print(game.world.world:getBodyCount(), 30, 50)
    love.graphics.print(game.player:getHealth(), 30, 80)

    for i = 1, game.player.inv_size do
        local item = game.player.inv_items[i]
        love.graphics.print("#" .. i .. ": " .. (type(item) == "table" and item.name .. " x" .. item.amount or "none"), 30, 80 + i * 30)
    end
end

function game:update(dt)
    -- update world and its entities
    game.world:update(dt)

    -- update timers
    Timer.update(dt)

    -- movement part
    local left   = game.input:isDown("move left")
    local right  = game.input:isDown("move right")
    local up     = game.input:isDown("move up")
    local down   = game.input:isDown("move down")
    local dx, dy = 0, 0

    if left and not right then dx = -1
    elseif right and not left then dx = 1 end

    if up and not down then dy = -1
    elseif down and not up then dy = 1 end

    -- move
    if game.player then
        game.player:move(dx, dy)

        -- make player look at the mouse
        local x, y = game.camera:getMousePosition()
        game.player:setRotation(math.atan2(y - game.player.pos.y, x - game.player.pos.x))

        -- input handling
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
        if game.input:justPressed("inventory next") then
            game.player.inv_selected = game.player.inv_selected - 1
            if game.player.inv_selected < 1 then
                game.player.inv_selected = game.player.inv_size
            end
        end
        if game.input:justPressed("inventory previous") then
            game.player.inv_selected = game.player.inv_selected + 1
            if game.player.inv_selected > game.player.inv_size then
                game.player.inv_selected = 1
            end
        end
        for i = 1, game.player.inv_size do
            if game.input:justPressed("inventory " .. i) then
                game.player.inv_selected = i
            end
        end
        if game.input:justPressed("use") then
            local item = game.player:getCurrentItem()
            if item and item.use then
                item:use()
            end
        end
    end

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
