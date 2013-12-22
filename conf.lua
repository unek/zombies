function love.conf(t)
    t.identity = "Zombies"
    t.version  = "0.9.0"
    t.console  = false

    t.window.title     = "Love Zombie Game"
    t.window.width     = 800
    t.window.height    = 600
    t.window.minwidth  = 640
    t.window.minheight = 480
    t.window.resizable = true

    t.modules.audio    = false
    t.modules.sound    = false
    t.modules.joystick = false

    t.window.fsaa = 4
end
