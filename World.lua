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

    if game.console:getVariable("lighting") then
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

    self.decals = {}

    self.explosions = {}
    self.world:setCallbacks(function(a, b, call)
        local particle
        if type(a:getUserData()) == "table" and a:getUserData().type == "ExplosionParticle" then
            particle = a
        elseif type(b:getUserData()) == "table" and b:getUserData().type == "ExplosionParticle" then
            particle = b
        end
        local damaged  = particle == a and b or a
        if particle then
            local x, y = particle:getBody():getLinearVelocity()
            local entity = self.entities[damaged:getUserData()]
            if entity and entity:hasComponent("Health") then
                local damage = (entity.pos.x ^ 2 + entity.pos.y ^ 2) ^ 0.5 / 25
                entity:damage(damage, particle:getUserData().owner)
            end
        end
    end)
end

-- from http://www.lua.org/pil/19.3.html
local function pairsByKey(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
     
    local i = 0 -- iterator variable
     
    return function() -- iterator function
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

    local z = (z or -1) * 1000
    while self.order[z] do
        if z < 0 then
            z = z - 1
        else
            z = z + 1
        end
    end

    self.order[z] = entity
    entity.z = z

    return id
end

function World:unregister(entity)
    self.order[entity.z] = nil
    self.entities[entity.id] = nil
end

function World:draw()
    love.graphics.setColor(255, 255, 255)

    love.graphics.setShader(game.console:getVariable("lighting") and self.terrain_shader or nil)
    love.graphics.draw(self.terrain)
    love.graphics.setShader()

    for z, entity in pairsByKey(self.order) do
        if entity.z > game.player.z
        and entity.testPoint
        and entity:testPoint(game.player.pos.x, game.player.pos.y) then
            love.graphics.setColor(255, 255, 255, 120)
        else
            love.graphics.setColor(255, 255, 255)
        end

        entity:draw()
    end

    love.graphics.setColor(255, 255, 255)

    if game.console:getVariable("debug") then
        love.graphics.setColor(255, 255, 0)
        for _, explosion in pairs(self.explosions) do
            for _, particle in pairs(explosion) do
                local x, y = particle.body:getPosition()
                love.graphics.circle("fill", x, y, 2)
            end
        end
    end
end

function World:update(dt)
    for _, entity in pairs(self.entities) do
        entity:update(dt)
    end

    -- update the box2d world
    self.world:update(dt)

    if game.console:getVariable("lighting") then
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

function World:explode(entity, y, power, owner)
    local x, y = entity, y
    if type(entity) == "table" then
        x, y = entity:getPosition()
    end

    local explosion = {}

    local num = 63
    -- spawn particles
    for i = 0, num do
        local angle  = (i / num) * math.pi * 2
        local dx, dy = math.sin(angle), math.cos(angle)
        explosion[i] = {}

        explosion[i].body = love.physics.newBody(self.world, x, y, "dynamic")
        explosion[i].body:setFixedRotation(true)
        explosion[i].body:setBullet(true)
        explosion[i].body:setLinearDamping(7)
        explosion[i].body:setGravityScale(0)
        explosion[i].body:setLinearVelocity(power * dx, power * dy)
        explosion[i].body:setPosition(x, y)

        explosion[i].shape = love.physics.newCircleShape(2)

        explosion[i].fixture = love.physics.newFixture(explosion[i].body, explosion[i].shape, 10)
        explosion[i].fixture:setFriction(0)
        explosion[i].fixture:setRestitution(0.99)
        explosion[i].fixture:setGroupIndex(-1)

        explosion[i].fixture:setUserData({ type = "ExplosionParticle", owner = owner })
    end

    table.insert(self.explosions, explosion)

    local decal = Entity:new(self, -1000)
        :addComponent("Transformable", x, y, math.random(0, math.pi*2))
        :addComponent("Color", 255, 255, 255, 200)
        :addComponent("Sprite", game.assets:getImage("burnmark"), power / 3, power / 3)

    self:addDecal(decal)

    Timer.add(0.4, function()
        for i, particle in pairs(explosion) do
            particle.fixture:destroy()
            particle.body:destroy()

            explosion[i] = nil
        end

        explosion = nil
    end)
end

function World:addDecal(entity)
    table.insert(self.decals, decal)

    if #self.decals > 100 then
        self.decals[1]:destroy()
        table.remove(self.decals, 1)
    end
end

function World:getPathIntersections(from, to)
    local x1, y1 = from:getPosition()
    local x2, y2 = to:getPosition()

    local hits = {}
    self.world:rayCast(x1, y1, x2, y2, function(fixture, x, y, xn, yn, fraction)
        -- ignore intersections with itself
        if fixture ~= to.physics_fixture then
            local hit = {}
            hit.fixture = fixture
            hit.x, hit.y = x, y
            hit.xn, hit.yn = xn, yn
            hit.fraction = fraction

            table.insert(hits, hit)
        end

        return 1
    end)

    return hits
end

return World
