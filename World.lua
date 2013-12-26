local World = Class("game.World")

function World:initialize(title, width, height, terrain)
    self.title    = title  or "World"

    self.width    = width  or 2048
    self.height   = height or 2048

    self.entities = {}
    self.order    = {}
    self._last_id = 0

    self.world    = love.physics.newWorld(0, 0)

    self.terrain  = terrain

    self.bounds          = {}
    self.bounds.body     = love.physics.newBody(self.world, 0, 0, "static")
    self.bounds.shapes   = {
        love.physics.newEdgeShape(0, 0, self.width, 0),
        love.physics.newEdgeShape(self.width, 0, self.width, self.height),
        love.physics.newEdgeShape(self.width, self.height, 0, self.height),
        love.physics.newEdgeShape(0, self.height, 0, 0)}
    self.bounds.fixtures = {}
    for i, shape in ipairs(self.bounds.shapes) do
        self.bounds.fixtures[i] = love.physics.newFixture(self.bounds.body, shape)
    end

    self.ambient_color = {80, 80, 80}

    self.decals = {}

    self.explosions = {}
    self.world:setCallbacks(function(a, b, call)
        local particle
        if type(a:getUserData()) == "table" and a:getUserData().type == "ExplosionParticle" then
            particle = a
        elseif type(b:getUserData()) == "table" and b:getUserData().type == "ExplosionParticle" then
            particle = b
        end
        local damaged = particle == a and b or a
        if particle then
            local x, y = particle:getBody():getLinearVelocity()
            local entity = self.entities[damaged:getUserData()]
            if entity and entity:hasComponent("Health") then

                local damage = ((entity.pos.x - x) ^ 2 + (entity.pos.y - y) ^ 2) ^ 0.5 / 25
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
    love.graphics.draw(self.terrain)

    for z, entity in pairsByKey(self.order) do
        if entity.z > game.player.z
        and entity.testPoint
        and entity:testPoint(game.player.pos.x, game.player.pos.y) then
            local r, g, b = unpack(self.ambient_color)
            love.graphics.setColor(r, g, b, 120)
        else
            love.graphics.setColor(self.ambient_color)
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
end

function World:explode(x, y, power, owner)
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
        :addComponent("Sprite", game.assets:getImage("burnmark", true), power / 3, power / 3)

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
    table.insert(self.decals, entity)

    if #self.decals > 200 then
        self.decals[1]:destroy()
        table.remove(self.decals, 1)
    end
end

function World:raycast(from, to, max)
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

        -- continue checking for hits
        return (max ~= nil and #hits < max) and 1 or 0
    end)

    return hits
end

function World:spawnPickup(x, y, item_name, amount, ...)
    local item = assert(game.item_registry[item_name], "no such item"):new(nil, amount, ...)
    return Entity:new(game.world, -100)
        :addComponent("Transformable", x, y)
        :addComponent("Pickup", item)
end

function World:getSize()
    return self.width, self.height
end

return World
