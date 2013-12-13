local InputManager = Class("InputManager")

function InputManager:initialize()
    self.binds = {}

    self.pressed  = {}
    self.released = {}
end

function InputManager:register(action, ...)
    local keys = {...}
    for _, key in ipairs(keys) do
        self.binds[key] = action
    end
end

function InputManager:isDown(action)
    for key, key_action in pairs(self.binds) do
        if action == key_action then
            if love.keyboard.isDown(key) then
                return true
            end
        end
    end
    return false
end

function InputManager:justPressed(action)
    for key, key_action in pairs(self.binds) do
        if action == key_action then
            if self.pressed[key] then
                return true
            end
        end
    end
    return false
end

function InputManager:justReleased(action)
    for key, key_action in pairs(self.binds) do
        if action == key_action then
            if self.released[key] then
                return true
            end
        end
    end
    return false
end

function InputManager:keypressed(key, is_repeat)
    if is_repeat then return end
    self.pressed[key] = true
end

function InputManager:keyreleased(key, is_repeat)
    if is_repeat then return end
    self.released[key] = true
end

function InputManager:update(dt)
    for key in pairs(self.pressed) do
        self.pressed[key] = nil
    end
    for key in pairs(self.released) do
        self.released[key] = nil
    end
end

return InputManager
