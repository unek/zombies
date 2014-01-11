local Gun = Item:extend("Gun")

function Gun:initialize(owner, amount, ammo, mag)
    Item.initialize(self, owner, amount)
    self.name         = "Gun"

    self.spread       = 0.03
    self.fire_speed   = 0.07
    self.reload_time  = 1
    self.bullet_speed = 1000

    self.automatic    = true

    self.recoil_max   = 1
    self.recoil_inc   = 0.2
    self.recoil_dec   = 2

    self.min_damage   = 15
    self.max_damage   = 60

    self.sprite       = game.assets:getImage("ak47")

    self.max_mag      = 30
    self.max_ammo     = 270

    self.ammo         = ammo or self.max_ammo
    self.mag          = mag or math.min(self.max_mag, self.ammo)

    self.reloading    = 0

    -- generate the bullet sprite
    local bullet      = love.image.newImageData(20, 2)
    bullet:mapPixel(function(x, y)
        return 255, 255, 0, math.min(1, x / bullet:getWidth()) * 2 * 255
    end)

    self.bullet_sprite = love.graphics.newImage(bullet)

    self.collide_func = function(bullet, entity)
        local shooter = bullet.owner
        if entity:hasComponent("Health") and entity ~= shooter then
            local damage = love.math.random(self.min_damage, self.max_damage)
            entity:damage(damage, shooter)
        end
    end
    self.body_collide_func = function(bullet, a, b)
        local shooter = bullet.owner
        if a ~= shooter.physics_fixture and b ~= shooter.physics_fixture then
            bullet:destroy()
        end
    end

    self.last_shot = 0
    self._power    = 0
end

function Gun:update(dt)
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
    end
    self._power = math.max(self._power - dt * self.recoil_dec, 0)
end

function Gun:shoot(single)
    if single == self.automatic
        or self.mag < 1
        or self.reloading > 0 
        or self.last_shot < self.fire_speed
        or not self:isHeld()
        or self.owner:emit("shoot", self.owner, self) then return end

    self.last_shot = 0

    self.mag = self.mag - 1

    -- bullets
    local power  = (self._power * self.spread + (self.owner:getSpeed() / self.owner:getMaxSpeed()) * .05)
    local radius = 1
    local spread = (love.math.random() * power) - power
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

    bullet.owner = self.owner

    local body = bullet:getBody()
    body:setBullet(true)
    body:setLinearVelocity(dx, dy)
    body:setLinearDamping(0)

    local fixture = bullet:getFixture()
    fixture:setGroupIndex(-1) -- thanks to that bullets don't collide with other bullets or explosions
    fixture:setUserData(bullet.id)

    bullet:on("collide", self.collide_func):on("body_collide", self.body_collide_func)

    self._power = math.min(self._power + self.recoil_inc, self.recoil_max)
end

function Gun:reload()
    if self.reloading > 0 or self.mag == self.max_mag or self.ammo < 1 then return end
    self.reloading = self.reload_time
end

function Gun:draw(x, y, size)
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
