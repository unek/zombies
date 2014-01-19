intro = {}

local timer = require("libraries.timer")
local font  = love.graphics.newFont(90)
local color = {255, 255, 255, 0}
local logo  = love.graphics.newImage("assets/love.png")

function intro:init()
    love.graphics.setBackgroundColor(0, 0, 0)

    timer.tween(1, color, {255, 255, 255, 255}, "linear", function()
        timer.add(1, function()
            timer.tween(1, color, {255, 255, 255, 0}, "linear", function()
                Gamestate.switch(game)
            end)
        end)
    end)
end

function intro:update(dt)
    timer.update(dt)
end

function intro:draw()
    local w, h  = love.graphics.getDimensions()
    local x, y  = (w - logo:getWidth()) / 2, (h - logo:getHeight()) / 2

    love.graphics.setColor(color)
    love.graphics.draw(logo, x, y)
end

function intro:keypressed(key, is_repeat)
    Gamestate.switch(game)
end

function intro:keypressed(key, is_repeat)
    Gamestate.switch(game)
end
