local World = Class("game.World")

function World:initialize(title, width, height, terrain, normals)
    self.title    = title  or "World"

    self.width    = width  or 1024
    self.height   = height or 1024

    self.entities = {}
    self._last_id = 0

    self.world    = love.physics.newWorld(0, 0)

    self.terrain  = love.graphics.newImage(terrain)

    self.ambient_color = {6, 6, 10}

    if game.config.lighting then
        self.terrain_shader = love.graphics.newShader("assets/bumpmap.frag")
        self.terrain_normal = love.graphics.newImage(normals)

        self.terrain_shader:send("material.normalmap", self.terrain_normal)
        self.terrain_shader:send("material.shininess", 50)
        self.terrain_shader:send("ambientcolor", {
              self.ambient_color[1] / 255
            , self.ambient_color[2] / 255
            , self.ambient_color[3] / 255
        })

        self.lights = {}

        self.max_lights = 30
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

    love.graphics.setShader(game.config.lighting and self.terrain_shader or nil)
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

    if game.config.lighting then
        for i, light in pairs(self.lights) do
            local l = string.format("Lights[%d].", i - 1)
            local x, y = game.camera:toCamera(unpack(light.position))

            self.terrain_shader:send(l.."position", { x, y, light.position[3] })
            self.terrain_shader:send(l.."color", {
                  (light.color[1] / 255) * light.intensity
                , (light.color[2] / 255) * light.intensity
                , (light.color[3] / 255) * light.intensity})
            self.terrain_shader:send(l.."radius", light.radius)
        end

        self.terrain_shader:send("numlights", #self.lights)
    end
end

return World
