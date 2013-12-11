function love.conf(t)
    t.identity = "Zombies"
    t.version  = "0.9.0"
    t.console  = false

    t.window.title     = "Love Zombie Game"
    t.window.width     = 1280
    t.window.height    = 720
    t.window.minwidth  = 800
    t.window.minheight = 600
    t.window.resizable = true

    t.window.fsaa = 4
end