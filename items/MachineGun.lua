local MachineGun = Item:extend("MachineGun")

function MachineGun:initialize(owner, amount, ammo, mag)
    Item.initialize(self, owner, amount)
    self.name         = "MachineGun"

    self.spread       = 0.03
    self.recoil       = 1
    self.fire_speed   = 0.07
    self.reload_time  = 1
    self.bullet_speed = 1000

    self.min_damage   = 15
    self.max_damage   = 60

    self.sprite       = game.assets:getImage("ak47")

    self.last_shot    = 0

    self.max_mag      = 30
    self.max_ammo     = 270

    self.ammo         = ammo or self.max_ammo
    self.mag          = mag or math.min(self.max_mag, self.ammo)

    self.reloading    = 0

    -- generate the bullet sprite
    local bullet      = love.image.newImageData(20, 1)
    bullet:mapPixel(function(x, y)
        return 255, 255, 0, math.min(1, x / bullet:getWidth()) * 2 * 255
    end)

    self.bullet_sprite = love.graphics.newImage(bullet)

    self._power        = 0

    self.collide_func  = function(self, entity)
        local gun    = self.owner
        local player = gun.owner
        if entity:hasComponent("Health") and entity ~= player then
            local damage = love.math.random(gun.min_damage, gun.max_damage)
            entity:damage(damage, player)
        end
    end
    self.body_collide_func = function(self, a, b)
        local gun    = self.owner
        local player = gun.owner
        if a ~= player.physics_fixture and b ~= player.physics_fixture then
            self:destroy()
        end
    end
end

function MachineGun:update(dt)
    self.last_shot = self.last_shot + dt

    if self:isHeld() then
        if self.reloading > 0 then
            self.reloading = math.max(0, self.reloading - dt)
            if self.reloading <= 0 then
                -- add the remaining ammo in mag to overall ammo
                self.ammo = self.ammo + self.mag

                -- get the maximum amount of ammo we can put in the mag
                local ammo = math.min(self.max_mag, self.ammo)
                -- take that amount from the overall ammo
                self.ammo = self.ammo - ammo
                -- and finally put it in the mag
                self.mag = ammo
            end
        end
        self._power = math.max(self._power - dt * 2, 0)
    end
end

function MachineGun:shoot()
    if self.mag < 1
        or self.reloading > 0 
        or self.last_shot < self.fire_speed
        or not self:isHeld()
        or self.owner:emit("shoot", self.owner, self) then return end

    self.last_shot = 0
    self._power    = math.min(self._power + 0.2, 1)

    self.mag = self.mag - 1

    -- bullets
    local radius = 1
    local spread = (love.math.random() * self._power * self.spread * 2) - self._power * self.spread
    local angle  = self.owner.rotation + spread
    local dx     = math.cos(angle) * self.bullet_speed
    local dy     = math.sin(angle) * self.bullet_speed
    local x, y   = self.owner:getPosition()

    x = x + math.cos(angle) * (self.owner.radius + radius)
    y = y + math.sin(angle) * (self.owner.radius + radius)

    local bullet = Entity:new(game.world)
        :addComponent("Transformable", x, y, angle)
        :addComponent("Sprite", self.bullet_sprite)
        :addComponent("ColliderCircle", radius)
        :addComponent("Physics", "dynamic")

    bullet.owner = self

    local body = bullet:getBody()
    body:setBullet(true)
    body:setLinearVelocity(dx, dy)
    body:setLinearDamping(0)

    local fixture = bullet:getFixture()
    fixture:setGroupIndex(-1) -- thanks to that bullets don't collide with other bullets or explosions
    fixture:setUserData(bullet.id)

    bullet:on("collide", self.collide_func):on("body_collide", self.body_collide_func)

    -- apply recoil to the shooter
    self.owner:getBody():applyLinearImpulse(
          math.cos(angle) * -self.recoil
        , math.sin(angle) * -self.recoil)
end

function MachineGun:reload()
    if self.reloading > 0 or self.mag == self.max_mag or self.ammo < 1 then return end
    self.reloading = self.reload_time
end

function MachineGun:draw(x, y, size)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.sprite, x - self.sprite:getWidth() / 2, y - self.sprite:getHeight() / 2)

    if self.owner then
        -- print the mag ammo amount
        local font  = game.assets:getFont("Roboto-Bold")[15]
        local label = tostring(self.ammo)

        love.graphics.setFont(font)
        love.graphics.print(label, x + size / 2 - font:getWidth(label), y + size / 2 - font:getHeight())
        
        -- draw mag, or if reloading, reload bar
        local amount = self.reloading > 0 and 1 + self.reloading / self.reload_time * -1 or self.mag / self.max_mag
        local length = amount * size

        love.graphics.setColor(255 - amount * 255, amount * 255, 255, 200)
        love.graphics.rectangle("fill", x - size / 2, y + size / 2, length, 3)
        
    end
end
