local World = Class("game.World")

-- last used entity id
local last_id = 0
function World:initialize(title, width, height, terrain)
    -- world name/title, to be used in minimaps, etc.
    self.title    = title  or "World"

    -- world's size
    self.width    = width  or 2048
    self.height   = height or 2048

    -- entities and their order
    self.entities = {}
    self.order    = {}

    -- box2d
    self.world    = love.physics.newWorld(0, 0)

    -- terrain sprite
    self.terrain  = terrain or game.assets._notexture

    -- define the world bounds
    self.bounds        = {}
    self.bounds.body   = love.physics.newBody(self.world, 0, 0, "static")
    self.bounds.shapes = {
        love.physics.newEdgeShape(0, 0, self.width, 0),
        love.physics.newEdgeShape(self.width, 0, self.width, self.height),
        love.physics.newEdgeShape(self.width, self.height, 0, self.height),
        love.physics.newEdgeShape(0, self.height, 0, 0)}
    self.bounds.fixtures = {}
    for i, shape in ipairs(self.bounds.shapes) do
        self.bounds.fixtures[i] = love.physics.newFixture(self.bounds.body, shape)
    end

    -- decal entities, aka blood, burn marks, etc.
    self.decals = {}

    -- explosion particles
    self.explosions = {}

    -- todo: rewrite explosions for the second time.
    local function getExplosionDamagee(a, b)
        local a_data = a:getUserData()
        local b_data = b:getUserData()
        if type(a_data) == "table" and a_data.type == "ExplosionParticle" then
            return self.entities[b_data], a
        elseif type(b_data) == "table" and b_data.type == "ExplosionParticle" then
            return self.entities[a_data], b
        end

        return false
    end

    self.world:setCallbacks(function(a, b, contact)
        -- handle explosion particles
        local entity, particle = getExplosionDamagee(a, b)
        if entity and entity:hasComponent("Health") then
            local x, y   = particle:getBody():getLinearVelocity()
            local damage = math.abs((x * x + y * y) ^ (1 / 3))
            entity:damage(damage, particle:getUserData().owner)
        end

        -- emit a collision event
        local a_data, b_data = a:getUserData(), b:getUserData()
        local a_entity, b_entity = self.entities[a_data], self.entities[b_data]
        if a_entity and b_entity then
            a_entity:emit("collide", b_entity)
            b_entity:emit("collide", a_entity)
        end

        if a_entity then
            a_entity:emit("body_collide", a, b)
        end
        if b_entity then
            b_entity:emit("body_collide", b, a)
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
    local id = last_id + 1
    last_id  = id

    -- put the entity into the table
    self.entities[id] = entity

    local z = (z or -1) * 100
    -- increase the z until we find a free one
    while self.order[z] do
        z = z < 0 and z - 1 or z + 1
    end

    -- entity's drawing order
    self.order[z] = entity
    entity.z      = z

    return id
end

function World:unregister(entity)
    local id = entity.id
    local z  = entity.z
    self.order[z] = nil
    self.entities[id] = nil

    -- breaks some things :(
    -- todo: fix.
    --if self.decals[id] then
    --    self.decals[id] = nil
    --end
end

function World:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.terrain)

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
end

function World:explode(x, y, power, owner)
    local sin, cos, pi = math.sin, math.cos, math.pi
    local power        = power or 1500
    local explosion    = {}
    local userdata     = { type = "ExplosionParticle", owner = owner }

    local num = 127
    -- spawn particles
    for i = 0, num do
        local angle  = (i / num) * pi * 2
        local dx, dy = sin(angle), cos(angle)
        explosion[i] = {}

        explosion[i].body = love.physics.newBody(self.world, x, y, "dynamic")
        explosion[i].body:setFixedRotation(true)
        explosion[i].body:setBullet(true)
        explosion[i].body:setLinearDamping(10)
        explosion[i].body:setGravityScale(0)
        explosion[i].body:setLinearVelocity(power * dx, power * dy)
        explosion[i].body:setPosition(x, y)

        explosion[i].shape = love.physics.newCircleShape(2)

        explosion[i].fixture = love.physics.newFixture(explosion[i].body, explosion[i].shape, 10)
        explosion[i].fixture:setFriction(0)
        explosion[i].fixture:setRestitution(0.99)
        explosion[i].fixture:setGroupIndex(-1)

        explosion[i].fixture:setUserData(userdata)
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
            local hit      = {}
            hit.fixture    = fixture
            hit.x, hit.y   = x, y
            hit.xn, hit.yn = xn, yn
            hit.fraction   = fraction

            table.insert(hits, hit)
        end

        -- continue checking for hits
        return (max ~= nil and #hits < max) and 1 or 0
    end)

    return hits
end

function World:spawnPickup(x, y, item_name, amount, ...)
    local item = item_name
    if type(item_name) == "string" then
        item = assert(game.item_registry[item_name], "no such item"):new(nil, amount, ...)
    end

    return Entity:new(game.world, -100)
        :addComponent("Transformable", x, y)
        :addComponent("Pickup", item)
end

function World:getSize()
    return self.width, self.height
end

return World
