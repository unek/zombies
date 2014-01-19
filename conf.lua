function love.conf(t)
    t.identity = "Zombies"
    t.version  = "0.9.0"
    t.console  = false

    t.window.title     = "Love Zombie Game"
    t.window.width     = 960
    t.window.height    = 540
    t.window.minwidth  = 640
    t.window.minheight = 480
    t.window.resizable = true

    t.modules.joystick = false

    t.window.fsaa  = 4
    t.window.vsync = false
end
