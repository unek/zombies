intro = {}

local timer = require("libraries.timer")
local font  = love.graphics.newFont(90)
local color = {0, 0, 0, 0}
local vignette = love.graphics.newImage("assets/vignette.png")

function intro:init()
    love.graphics.setBackgroundColor(255, 255, 255)

    timer.tween(2, color, {0, 0, 0, 255}, "linear", function()
        timer.add(2, function()
            timer.tween(2, color, {0, 0, 0, 0}, "linear", function()
                Gamestate.switch(game)
            end)
        end)
    end)
end

function intro:update(dt)
    timer.update(dt)
end

function intro:draw()
    local label = "Zombies"
    local w, h  = love.graphics.getDimensions()
    local x, y  = (w - font:getWidth(label)) / 2, (h - font:getHeight()) / 2

    love.graphics.setColor(color)
    love.graphics.setFont(font)
    love.graphics.print(label, x, y)

    love.graphics.setColor(255, 255, 255, 180)
    love.graphics.draw(vignette, 0, 0, 0, w / vignette:getWidth(), h / vignette:getHeight())
end

function intro:keypressed(key, is_repeat)
    Gamestate.switch(game)
end

function intro:keypressed(key, is_repeat)
    Gamestate.switch(game)
end
