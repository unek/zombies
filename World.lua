local World = Class("game.World")

function World:initialize(title, width, height)
    self.title  = title  or "World"

    self.width  = width  or 1024
    self.height = height or 1024

    self.entities = {}
    self._last_id = 0

    self.world = love.physics.newWorld()

    self.terrain = love.graphics.newImage("test/canvas.png")

    if game.lighting then
        self.terrain_shader = love.graphics.newShader("assets/bumpmap.frag")
        self.terrain_normal = love.graphics.newImage("test/normals.png")

        self.terrain_shader:send("material.normalmap", self.terrain_normal)
        self.terrain_shader:send("material.shininess", 50)
        self.terrain_shader:send("ambientcolor", {(60/255)^2.2, (60/255)^2.2, (60/255)^2.2})

        self.lights = {}

        self.lights[1] = { position = { 400, 300, 60 }, color = { 1, 0, 1 }, radius = 300, intensity = 1.5 }
    end
end

function World:register(entity)
    local id      = self._last_id + 1
    self._last_id = id

    self.entities[id] = entity

    return id
end

function World:unregister(entity)
    self.entities[entity.id] = nil
end

function World:draw()
    love.graphics.setColor(255, 255, 255)

    love.graphics.setShader(game.lighting and self.terrain_shader or nil)
    love.graphics.draw(self.terrain)
    love.graphics.setShader()

    for _, entity in pairs(self.entities) do
        entity:draw()
    end

    love.graphics.setColor(255, 255, 255)
end

function World:update(dt)
    for _, entity in pairs(self.entities) do
        entity:update(dt)
    end

    -- update the box2d world
    self.world:update(dt)

    if game.lighting then
        for i, light in pairs(self.lights) do
            local l = string.format("Lights[%d].", i - 1)

            self.terrain_shader:send(l.."position", light.position)
            self.terrain_shader:send(l.."color", {
                  light.color[1] * light.intensity
                , light.color[2] * light.intensity
                , light.color[3] * light.intensity})
            self.terrain_shader:send(l.."radius", light.radius)
        end

        self.terrain_shader:send("numlights", #self.lights)
    end
end

return World
