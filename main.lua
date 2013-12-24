-- external libs
Class     = require("libraries.middleclass")
Gamestate = require("libraries.gamestate")

Console   = require("Console")

AssetManager = require("AssetManager")

-- gamestates
require("Game")
function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    -- input management
    game.input   = InputManager:new()

    -- asset management
    game.assets = AssetManager:new("assets/")

    -- console
    game.console = Console:new()

    -- register command for binding buttons
    game.console:registerCommand("bind", function(argv)
        local key    = assert(argv[1], "no key/button (arg #1) specified")
        local action = assert(argv[2], "no action (arg #2) specified")

        game.input:register(action, key)
        return ("bound %q to %q"):format(key, action)
    end)

    game.console:registerCommand("mode", function(argv)
        local width, height, flags = love.window.getMode()
        if argv[1] == "fullscreen" then
            flags.fullscreen = true
        elseif argv[1] == "windowed" then
            flags.fullscreen = false
        elseif argv[1] == "borderless" then
            flags.borderless = true
        else
            error("unknown mode " .. argv[1])
        end

        love.window.setMode(width, height, flags)
    end)

    game.console:registerCommand("resize", function(argv)
        local width  = assert(argv[1], "no width (arg #1) specified")
        local height = assert(argv[2], "no height (arg #2) specified")
        local _, _, flags = love.window.getMode()

        love.window.setMode(width, height, flags)
    end)
    game.console:registerVariable("vsync", function(value)
        local value = assert(type(value) == "boolean" and value, "vsync has to be a boolean")
        local width, height, flags = love.window.getMode()

        flags.vsync = value

        love.window.setMode(width, height, flags)
    end)

    -- create autoexec.cfg if doesn't exist
    if not love.filesystem.exists("autoexec.cfg") then
        love.filesystem.write("autoexec.cfg", love.filesystem.read("sample.cfg"))
    end

    game.console:execFile("sample.cfg")
    --game.console:execFile("autoexec.cfg")

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
