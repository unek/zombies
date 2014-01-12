local InputManager = Class("InputManager")

function InputManager:initialize()
    self.kb          = {}
    self.kb.binds    = {}
    self.kb.pressed  = {}
    self.kb.released = {}

    self.m          = {}
    self.m.binds    = {}
    self.m.pressed  = {}
    self.m.released = {}
end

function InputManager:getKeys(action)
    local keys = {}

    -- keyboard binds
    for key, key_action in pairs(self.kb.binds) do
        if action == key_action then
            table.insert(keys, key)
        end
    end

    return keys
end

function InputManager:getButtons(action)
    local buttons = {}

    -- mouse binds
    for button, button_action in pairs(self.m.binds) do
        if action == button_action then
            table.insert(buttons, button)
        end
    end

    return buttons
end

function InputManager:register(action, ...)
    local keys = {...}
    for _, key in ipairs(keys) do
        local key = tostring(key)
        if key:match("^mouse%s") then
            local button = key:match("^mouse%s(.*)")
            if button == "left" then button = "l" end
            if button == "right" then button = "r" end
            if button == "middle" then button = "m" end
            if button == "wheel" then button = "m" end
            if button == "wheel up" then button = "wu" end
            if button == "wheel down" then button = "wd" end
            self.m.binds[button] = action
        else
            if key == "space" then key = " " end
            if key:match("^left%s") then key = "l" .. key:match("^left%s(.*)") end
            if key:match("^right%s") then key = "r" .. key:match("^right%s(.*)") end
            self.kb.binds[key] = action
        end
    end
end

function InputManager:isDown(action)
    if not love.window.hasFocus() then
        return false
    end
    
    for _, key in pairs(self:getKeys(action)) do
        if love.keyboard.isDown(key) then return true end
    end

    for _, button in pairs(self:getButtons(action)) do
        if love.mouse.isDown(button) then return true end
    end

    return false
end

function InputManager:justPressed(action)
    for _, key in pairs(self:getKeys(action)) do
        if self.kb.pressed[key] then return true end
    end

    for _, button in pairs(self:getButtons(action)) do
        if self.m.pressed[button] then return true end
    end

    return false
end

function InputManager:justReleased(action)
    for _, key in pairs(self:getKeys(action)) do
        if self.kb.released[key] then return true end
    end

    for _, button in pairs(self:getButtons(action)) do
        if self.m.released[button] then return true end
    end

    return false
end

function InputManager:keypressed(key, is_repeat)
    if is_repeat then return end
    self.kb.pressed[key] = true
end

function InputManager:keyreleased(key, is_repeat)
    if is_repeat then return end
    self.kb.released[key] = true
end

function InputManager:update(dt)
    for key in pairs(self.kb.pressed) do
        self.kb.pressed[key] = nil
    end
    for key in pairs(self.kb.released) do
        self.kb.released[key] = nil
    end
    for button in pairs(self.m.pressed) do
        self.m.pressed[button] = nil
    end
    for button in pairs(self.m.released) do
        self.m.released[button] = nil
    end
end

function InputManager:mousepressed(x, y, button)
    self.m.pressed[button] = true
end

function InputManager:mousereleased(x, y, button)
    self.m.released[button] = true
end

return InputManager
