local MachineGun = game.item_registry.Gun:extend("MachineGun")

-- todo: merge it with machinegun
-- todo: maybe find some better names for variables
function MachineGun:initialize(owner, amount, ammo, mag)
    game.item_registry.Gun.initialize(self, owner, amount, ammo, mag)
    self.name         = "MachineGun"

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
end
