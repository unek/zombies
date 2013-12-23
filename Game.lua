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
        :addComponent("Health", 10000)
        :addComponent("HealthIndicator", 15)
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

    -- make the camera follow the player
    game.camera:follow(game.player)
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

        -- draw the big numbers
        love.graphics.setFont(huge_font[35])
        love.graphics.setColor(255, 255, 255, 120)
        love.graphics.print(i, x + size - huge_font[35]:getWidth(i) - size / 4, y + (size - huge_font[35]:getHeight()) / 2)

        local item = game.player.inv_items[i]
        if item then
            -- draw the item sprite
            if item.object[1].draw then
                item.object[1]:draw(x + size / 2, y + size / 2)
            end

            -- print the item count
            if item.count > 1 then
                local label = "x" .. item.count
                local w     = bold_font[15]:getWidth(label)
                local h     = bold_font[15]:getHeight(label)

                love.graphics.setFont(bold_font[15])
                love.graphics.setColor(255, 255, 255)
                love.graphics.print(label, x + size - w, y + size - h)
            end
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
        love.graphics.print("#" .. i .. ": " .. (type(item) == "table" and item.object.name .. " x" .. item.count or "none"), 30, 80 + i * 30)
    end
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
    for i = 0, 9 do
        if game.player.inv_size >= i and game.input:justPressed("inventory " .. i) then
            game.player.inv_selected = i
        end
    end
    if game.input:justPressed("use") then
        local item = game.player:getCurrentItem()
        if item and item.object and item.object.use then
            item.object:use()
        end
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
