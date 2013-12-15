-- external libs
Class     = require("libraries.middleclass")
Gamestate = require("libraries.gamestate")

Console   = require("Console")
Config    = require("Config")

HUD       = setmetatable({}, {__index = function() return function() end end})--require("libraries.hud")

-- gamestates
require("Game")
function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    Gamestate.switch(game)
end

function love.draw()
    Gamestate.draw()
    HUD.draw()
end

function love.update(dt)
    Gamestate.update(dt)

    HUD.update(dt)
end

function love.keypressed(key, is_repeat)
    Gamestate.keypressed(key, is_repeat)

    HUD.keypressed(key, is_repeat)
end

function love.keyreleased(key, is_repeat)
    Gamestate.keyreleased(key, is_repeat)

    HUD.keyreleased(key, is_repeat)
end

function love.mousepressed(x, y, button)
    Gamestate.mousepressed(x, y, button)

    HUD.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    Gamestate.mousereleased(x, y, button)

    HUD.mousereleased(x, y, button)
end