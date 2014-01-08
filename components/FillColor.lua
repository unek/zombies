local FillColor = Component:extend("FillColor")

function FillColor:initialize(r, g, b, a)
    self.fill_color = {r, g, b, a}
end

function FillColor:setFillColor(r, g, b, a)
    self.fill_color = {r, g, b, a}

    return self
end

function FillColor:setFillColor()
    return unpack(self.fill_color)
end
