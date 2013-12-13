local World = Class("game.World")

function World:initialize(title, width, height, terrain, normals)
    self.title    = title  or "World"

    self.width    = width  or 2048
    self.height   = height or 2048

    self.entities = {}
    self.order    = {}
    self._last_id = 0

    self.world    = love.physics.newWorld(0, 0)

    self.terrain  = love.graphics.newImage(terrain)

    self.bounds          = { body = love.physics.newBody(self.world, 0, 0, 'static') }
    self.bounds.shapes   = {
        love.physics.newEdgeShape(0, 0, self.width, 0),
        love.physics.newEdgeShape(self.width, 0, self.width, self.height),
        love.physics.newEdgeShape(self.width, self.height, 0, self.height),
        love.physics.newEdgeShape(0, self.height, 0, 0)}
    self.bounds.fixtures = {}
    for i, shape in ipairs(self.bounds.shapes) do
        self.bounds.fixtures[i] = love.physics.newFixture(self.bounds.body, shape)
    end

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

-- from http://www.lua.org/pil/19.3.html
local function pairsByKey(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
     
    local i = 0 -- iterator variable
     
    return function () -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
end

function World:register(entity, z)
    local id      = self._last_id + 1
    self._last_id = id

    self.entities[id] = entity

    local z = z or 0
    while self.order[z] do
        z = z + 1
    end

    self.order[z] = entity

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

    for z, entity in pairsByKey(self.order) do
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
