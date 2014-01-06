local Vehicle = Component:extend("Vehicle")

function Vehicle:initialize()
    self.driver = nil

    self.seat_pos   = {}
    self.seat_pos.x = self.pos.x
    self.seat_pos.y = self.pos.y
end

function Vehicle:setDriver(driver)
    if self.driver or not driver then
        self:removeChild(self.driver)

        self.driver = nil
    end
    self:addChild(driver)

    self.driver = driver
    self.driver:setPosition(self.seat_pos.x, self.seat_pos.y)

    return self
end

function Vehicle:getDriver()
    return self.driver
end
