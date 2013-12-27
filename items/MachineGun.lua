local MachineGun = Item:extend("MachineGun")

function MachineGun:initialize(owner, amount)
    Item.initialize(self, owner, amount)
    self.name      = "MachineGun"

    self.recoil      = 1
    self.fire_speed  = 0.07
    self.reload_time = 1

    self.sprite      = game.assets:getImage("ak47")

    self.last_shot   = 0

    self.max_mag     = 30
    self.max_ammo    = 270

    self.ammo        = self.max_ammo
    self.mag         = self.max_mag

    self.reloading   = 0
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
        if game.input:isDown("shoot") and self.reloading <= 0 then
            if self.last_shot >= self.fire_speed then
                if not self.owner:emit("shoot", self) then
                    self:shoot()
                end

                self.last_shot = 0
            end
        end
        if game.input:justPressed("reload") then
            self:reload()
        end
    end
end

function MachineGun:shoot()
    if self.mag < 1 or self.reloading > 0 then return end
    self.mag = self.mag - 1

    -- awesome bullets
    Entity:new(game.world)
        :addComponent("Transformable", game.camera:getMousePosition())
        :addComponent("Color", 0, 0, 0)
        :addComponent("RenderCircle", 5)
end

function MachineGun:reload()
    if self.reloading > 0 or self.mag == self.max_mag then return end
    self.reloading = self.reload_time
end

function MachineGun:draw(x, y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(self.sprite, x - self.sprite:getWidth() / 2, y - self.sprite:getHeight() / 2)

    if self.owner then
        -- print the mag ammo amount
        local font  = game.assets:getFont("Roboto-Bold")[15]
        local label = tostring(self.mag)

        love.graphics.setFont(font)
        love.graphics.print(self.mag, x + 21 - font:getWidth(label), y + 21 - font:getHeight())
        
        -- draw reload bar
        if self.reloading > 0 then
            local amount = self.reloading / self.reload_time
            local length = amount * 42

            love.graphics.setColor(255 - amount * 255, amount * 255, 255, 200)
            love.graphics.rectangle("fill", x - 21, y + 21, length, 3)
        end
    end
end
