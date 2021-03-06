-- some basic objects
Entity        = require("Entity")
Component     = require("Component")
EntityFactory = require("EntityFactory")

Item = require("Item")

World  = require("World")
Camera = require("Camera")

InputManager = require("InputManager")

Timer = require("libraries.timer")

require("hud")

-- this creates the game, the rest isn't really important
game = {}

-- registries
game.component_registry = {}
game.item_registry      = {}

-- require basic components
require("components")
require("items")

function game:init()
    -- set background color to black
    love.graphics.setBackgroundColor(0, 0, 0)

    -- the camera
    game.camera  = Camera:new()

    -- load create the world
    game.world   = World:new("World", 2048, 2048, game.assets:getImage("supermap"))

    -- testing player
    game.player  = Entity:new(game.world)
        :addComponent("Transformable", 400, 300)
        :addComponent("Health", 200)
        :addComponent("HealthIndicator", 15)
        :addComponent("Bleeding")
        :addComponent("RenderCircle", 9, 40)
        :addComponent("FillColor", 190, 43, 43)
        :addComponent("ColliderCircle")
        :addComponent("Physics", "dynamic", 0.37)
        :addComponent("Movement", 200)
        :addComponent("Inventory", 4)

    game.crate_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", game.assets:getImage("metal_crate"), 128, 128)
        :addComponent("ColliderRectangle")
        :addComponent("Physics", "dynamic", 100)

    game.sedan_factory = EntityFactory:new()
        :addComponent("Transformable")
        :addComponent("Sprite", game.assets:getImage("sedan"), 252, 120)
        :addComponent("ColliderRectangle", 0, 0, 227, 105)
        :addComponent("Physics", "dynamic")
        :addComponent("Vehicle")

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
        :addComponent("RenderCircle", 9)
        :addComponent("FillColor", 43, 190, 43)
        :addComponent("ColliderCircle", 9)
        :addComponent("Physics", "dynamic", 0.37)
        :addComponent("Movement", 150)
        :addComponent("Health", 100)
        :addComponent("Bleeding")
        :addComponent("SimpleFollowAI", game.player)
        :addComponent("HealthIndicator")
        :addComponent("MeleeAttacker")

    game.crate_factory:spawn(game.world, 100):setPosition(400, 100):setRotation(math.pi / 5)
    game.tree_factory:spawn(game.world, 200):setPosition(220, 350)
    game.sedan_factory:spawn(game.world, 100):setPosition(350, 120)

    game.world:spawnPickup(250, 250, "Medkit", 1)
    game.world:spawnPickup(200, 250, "HandGun", 1)
    game.world:spawnPickup(250, 300, "Medkit", 1)
    game.world:spawnPickup(250, 350, "Medkit", 1)
    game.world:spawnPickup(200, 300, "Medkit", 1)
    game.world:spawnPickup(200, 350, "Medkit", 1)
    game.world:spawnPickup(250, 450, "MachineGun", 1)

    -- make the camera follow the player
    game.camera:follow(game.player)

    game.player:on("death", function(self, killer)
        Gamestate.push(gameover)

        -- refuse to destroy the player entity
        -- it seems to screw up some things.
        -- todo: fix those things
        return true
    end)

    -- reset vignette
    game.vignette = 0.8

    -- hide cursor
    love.mouse.setVisible(false)

    -- weather conditions
    game.raindrops = {}
    game.clouds    = {}

    local function spawnRaindrop()
        local w, h = love.window.getDimensions()
        local pad  = 100
        local x, y

        -- picks a random screen side and spawns a raindrop off-screen
        local side = math.random(1, 4)
        if side == 1 then
            x = -pad
            y = math.random(0, h)
        elseif side == 2 then
            x = math.random(0, w)
            y = -pad
        elseif side == 3 then
            x = w + pad
            y = math.random(h)
        elseif side == 4 then
            x = math.random(w)
            y = h + pad
        end

        local raindrop = {}
        raindrop.x     = x
        raindrop.y     = y
        raindrop.time  = love.timer.getTime()
        raindrop.angle = math.atan2(h / 2 - y, w / 2 - x)
        raindrop.dx    = math.cos(raindrop.angle) * 700
        raindrop.dy    = math.sin(raindrop.angle) * 700
        table.insert(game.raindrops, raindrop)
    end

    -- spawn 3 raindrops every 60 times a second
    Timer.addPeriodic(1 / 60, function() for i = 1, 3 do spawnRaindrop() end end)

    -- spawn some clouds
    for i = 1, 120 do
        local x = math.random(-game.world.width, game.world.width)
        local y = math.random(-game.world.height, game.world.height)

        local cloud  = {}
        cloud.x      = x
        cloud.y      = y
        cloud.sprite = game.assets:getImage("cloud", true)

        table.insert(game.clouds, cloud)
    end
end

function game:draw()
    love.graphics.setBlendMode("alpha")
    game.camera:push()
        game.world:draw()
    game.camera:pop()

    local w, h = love.window.getDimensions()
    
    for i, raindrop in pairs(game.raindrops) do
        local x, y   = raindrop.x, raindrop.y
        local time   = raindrop.time
        local angle  = raindrop.angle
        local dt     = love.timer.getTime() - time
        local dx, dy = raindrop.dx * dt, raindrop.dy * dt
        local length = 50
        local dist   = (((w / 2) - (x + dx)) ^ 2 + ((h / 2) - (y + dy)) ^ 2) ^ .5 - length

        love.graphics.setColor(200, 240, 255, (dist / h / 2) * 180)
        love.graphics.line(x + dx, y + dy, x + dx + math.cos(angle) * length, y + dy + math.sin(angle) * length)

        if dist < 150 then
            game.raindrops[i] = nil
        end
    end
    
    -- draw clouds
    local px, py = -game.camera.pos.x, -game.camera.pos.y
    
    love.graphics.setColor(255, 255, 255, 120)
    for _, cloud in pairs(game.clouds) do
        local x, y = px + cloud.x, py + cloud.y
        local w, h = cloud.sprite:getWidth(), cloud.sprite:getHeight()

        if x < w and 0 < x + w and y < h and 0 < y + h then
            love.graphics.draw(cloud.sprite, x, y)
        end
    end

    -- color correction
    love.graphics.setColor(20, 30, 80, 60)
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- draw a nice vignette
    local vignette = game.assets:getImage("vignette")
    love.graphics.setColor(255, 255, 255, game.vignette * 255)
    love.graphics.draw(vignette, 0, 0, 0, w / vignette:getWidth(), h / vignette:getHeight())
    love.graphics.setBlendMode("alpha")

    -- todo: move it to some kind of hud lib
    local bold_font = game.assets:getFont("Roboto-Bold")
    local huge_font = game.assets:getFont("Roboto-Black")
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

    -- draw crosshair
    local thickness = 2
    local item   = game.player:getCurrentItem()
    local power  = (item and item._power or 0)
    local length = 10 + power * 5
    local radius = 10 + (game.player:getSpeed() / game.player:getMaxSpeed()) * 5 + power * 10
    local x, y   = love.mouse.getPosition()

    love.graphics.setColor(255, 255, 255, 255)
    -- center
    love.graphics.rectangle("fill", x - thickness / 2, y - thickness / 2, thickness, thickness)
    -- reload timer
    local item    = game.player:getCurrentItem()
    local amount = item and item.reloading and (item.reloading > 0 and 1 - item.reloading / item.reload_time)
    if amount then
        local vertices = {}
        local segments = 40
        local radius   = radius + length / 2

        for i = 0, math.floor(amount * segments) do
            local theta = (i / segments) * math.pi * 2
            table.insert(vertices, x + math.cos(theta) * radius)
            table.insert(vertices, y + math.sin(theta) * radius)
        end

        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setLineWidth(2)
        if #vertices >= 4 then
            love.graphics.line(unpack(vertices))
        end
    else
        -- remaining ammo
        local amount = item and item:isInstanceOf(game.item_registry.Gun) and (item.mag / item.max_mag)
        if amount then
            local vertices = {}
            local segments = 40
            local radius   = radius + length / 2

            for i = 0, math.floor(amount * segments) do
                local theta = (i / segments) * math.pi * 2
                table.insert(vertices, x + math.cos(theta) * radius)
                table.insert(vertices, y + math.sin(theta) * radius)
            end

            local r = 255 -- we always want a bit of red, don't we
            local g = math.max(0, math.min(255, 255 * (amount - 0.25) * 4)) -- tween from yellow to red when ammo decreases from half to 1/4
            local b = math.max(0, 255 - (510 * (1 - amount))) -- tween from white to yellow when ammo decreases from max to half

            love.graphics.setColor(r, g, b, 255)
            love.graphics.setLineWidth(2)
            if #vertices >= 4 then
                love.graphics.line(unpack(vertices))
            end
        end
        love.graphics.setColor(255, 255, 255, 255)
        -- horizontal lines
        love.graphics.rectangle("fill", x - length - radius, y - thickness / 2, length, thickness)
        love.graphics.rectangle("fill", x + radius, y - thickness / 2, length, thickness)
        -- vertical lines
        love.graphics.rectangle("fill", x - thickness / 2, y - length - radius, thickness, length)
        love.graphics.rectangle("fill", x - thickness / 2, y + radius, thickness, length)
    end

    if item and item.name then
        local font = game.assets:getFont("Roboto-Bold")[18]
        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(font)
        love.graphics.print(item.name, (w - font:getWidth(item.name)) / 2, h - font:getHeight() - 20)
    end

    -- draw hud objects
    hud.draw()
end

function game:update(dt)
    -- update world and its entities
    game.world:update(dt)

    -- move clouds
    for i, cloud in pairs(game.clouds) do
        cloud.x = cloud.x + dt * 15
        cloud.y = cloud.y + dt * 15

        -- if the cloud went off-screen, replace it with a brand new one
        if cloud.x > game.world.width or cloud.y > game.world.height then
            local w, h      = cloud.sprite:getDimensions()
            local newcloud  = {}
            newcloud.x      = math.random(-game.world.width - w, -w)
            newcloud.y      = math.random(-game.world.height - h, -h)
            newcloud.sprite = cloud.sprite
            game.clouds[i]  = newcloud
        end
    end

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
            game.player:useItem()
        end
        if game.input:justPressed("reload") then
            game.player:reloadItem()
        end
        if game.input:isDown("shoot") then
            game.player:shootItem(game.input:justPressed("shoot"))
        end
    end

    -- update hud objects
    hud.update(dt)

    -- update input
    game.input:update(dt)
end

function game:mousepressed(x, y, button)
    game.input:mousepressed(x, y, button)
    
    hud.mousepressed(x, y, button)
end

function game:mousereleased(x, y, button)
    game.input:mousereleased(x, y, button)

    hud.mousereleased(x, y, button)
end

function game:keypressed(key)
    game.input:keypressed(key)
end

function game:keyreleased(key)
    game.input:keyreleased(key)
end

function game:resize(width, height)
    game.world:refresh()
end
