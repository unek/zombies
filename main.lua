-- external libs
Class     = require("libraries.middleclass")
Gamestate = require("libraries.gamestate")

Console   = require("Console")

-- gamestates
require("Game")
function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    Gamestate.switch(game)
end

function love.draw()
    Gamestate.draw()
end

function love.update(dt)
    Gamestate.update(dt)
end

function love.keypressed(key, is_repeat)
    Gamestate.keypressed(key, is_repeat)
end

function love.keyreleased(key, is_repeat)
    Gamestate.keyreleased(key, is_repeat)
end

function love.mousepressed(x, y, button)
    Gamestate.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    Gamestate.mousereleased(x, y, button)
end