local FillTexture = Component:extend("FillTexture")

function FillTexture:initialize(image)
    self:setFillTexture(image)
end

function FillTexture:setFillTexture(image)
    self.fill_texture = image
    self.mesh:setImage(self.fill_texture)

    return self
end
