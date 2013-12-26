local Gun = Item:extend("Gun")

function Gun:initialize(owner, amount)
    Item.initialize(self, owner, amount)
    self.name      = "Medkit"
    self.max_stack = 1

    self.health    = 75
end

