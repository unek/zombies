-- important stuff
Class = require("libraries.middleclass")

-- this stuff is also important
Entity    = require("Entity")
Component = require("Component")

-- creates the game, the rest of the code isn't important
game = {}

-- registries
game.component_registry = {}
-- managers

-- factories


function love.load()
    -- enables instant output to sublime text console
    io.stdout:setvbuf("no")

    -- hello world!
    print("The game loaded")
end
