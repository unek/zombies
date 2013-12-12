local Config = {}

Config.default = {debug=true, lighting=true}

function Config:read(t)

    local ConfigFile = love.filesystem.newFile("config", "r")

    self.indexes = {}
    local n = 0

    if not ConfigFile then
        
        for index, value in pairs(self.default) do
            n = n + 1

            t[index] = value
            self.indexes[n] = index

        end

    else

        for line in ConfigFile:lines() do
            n = n + 1

            local index, value = line:match("([%l_][%l%d_]*)%:(.+)")
            t[index] = loadstring("return "..value)()
            self.indexes[n] = index

        end

        ConfigFile:close()
    end

end


function Config:save(t, indexes)
    
    local ConfigFile = love.filesystem.newFile("config", "w")

    for _, index in ipairs(indexes or self.indexes) do
        local value = t[index]

        value = type(value) == "function" and string.dump(value) or value
        ConfigFile:write(index .. ":" .. tostring(value))

        if _ ~= #self.indexes then
            ConfigFile:write("\n")
        end

    end

    ConfigFile:close()
end

return Config