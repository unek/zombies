local HandGun = game.item_registry.Gun:extend("HandGun")

-- todo: merge it with machinegun
-- todo: maybe find some better names for variables
function HandGun:initialize(owner, amount, ammo, mag)
    game.item_registry.Gun.initialize(self, owner, amount, ammo, mag)
    self.name         = "Revolver"

    self.spread       = 0.005
    self.fire_speed   = 0.4
    self.reload_time  = 0.8
    self.bullet_speed = 1000

    self.automatic    = false

    self.recoil_max   = 1.5
    self.recoil_inc   = 1
    self.recoil_dec   = 1

    self.min_damage   = 40
    self.max_damage   = 120

    self.sprite       = game.assets:getImage("revolver")

    self.max_mag      = 7
    self.max_ammo     = 35

    self.ammo         = ammo or self.max_ammo
    self.mag          = mag or math.min(self.max_mag, self.ammo)
end
