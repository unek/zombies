local Console = Class("Console")

function Console:initialize()
    self.handlers    = {}
    self.variables   = {}
    self.varhandlers = {}

    self:registerCommand("set", function(argv)
        local cvar  = assert(argv[1], "specify the variable to set")
        local value = assert(argv[2], "specify the value")

        -- convert booleans and numerics
        if value == "true" or value == "on" then
            value = true
        elseif value == "false" or value == "off" then
            value = false
        elseif tonumber(value) then
            value = tonumber(value)
        end

        if self.varhandlers[cvar] then
            local success, value = pcall(self.varhandlers[cvar], value)
            if success then
                self.variables[cvar] = value
            else
                error(("could not set %q to %q: %s"):format(cvar, value, value))
            end
        else
            self.variables[cvar] = value
        end

        return ("%q set to %q."):format(cvar, tostring(value))
    end)
    self:registerCommand("get", function(argv)
        return self.variables[assert(argv[1], "specify the variable to get")] or error("no such variable")
    end)
    self:registerCommand("exec", function(argv)
        return self:execFile(assert(argv[1], "no file specified"))
    end)
end

function Console:getVariable(cvar)
    return self.variables[cvar]
end

function Console:print(...)
    print(...)
end

function Console:error(...)
    return self:print(...)
end

function Console:registerCommand(command, callback)
    self.handlers[command] = callback
end

function Console:registerVariable(variable, callback)
    self.varhandlers[variable] = callback
end

function Console:parseLine(line)
    -- comments
    if line:find("^[%s]*#") then return end
    local params = {}
    local i      = 0
    local quoted = false

    -- parse every value
    for value in line:gmatch("[^%s]+") do
        -- quoted values without spaces
        if value:match("^%b\"\"$") and not quoted then
            table.insert(params, value:match("^\"(.*)\"$"))
        -- beginning of a quote value
        elseif value:sub(0, 1) == "\"" and not quoted then
            quoted = (value .. " "):gsub("\\\"", "\"")
        -- ending of a quoted value
        elseif value:sub(value:len()) == "\"" and value:sub(value:len() - 1) ~= "\\\"" and quoted then
            table.insert(params, (quoted .. value:gsub("\\\"", "\"")):match("^\"(.*)\"$"))
            quoted = false
        else
            if quoted then
                -- continuation of a quoted value
                quoted = quoted .. value:gsub("\\\"", "\"") .. " "
            else
                -- normal, unquoted values
                local value = value:gsub("\\\"", "\"")
                table.insert(params, value)
            end
        end
    end

    -- error if a matching quote was not found
    if quoted then
        return "unmatched quote, be sure to separate every argument with a space and escape every quote within values"
    end

    return params
end

function Console:run(line)
    local params = self:parseLine(line)
    if type(params) == "string" then
        return false, params
    elseif not params or #params == 0 then
        return true
    end
    local command = params[1]
    table.remove(params, 1)

    -- find a handler
    local handler = self.handlers[command]
    if not handler then return "command not found" end

    -- pcall the handler so whole app doesn't crash on an error
    local success, result = pcall(handler, params)

    -- skip filename and line number
    result = success and result or result:gsub("^(.-): ", "")
    return success, result
end

function Console:exec(line)
    local success, result = self:run(line)

    if not success then
        return self:error(result)
    end

    if result then
        self:print(result)
    end
end

function Console:execFile(file)
    if not love.filesystem.exists(file) then
        return ("file %q doesn't exist"):format(file)
    end

    local i = 0
    for line in love.filesystem.lines(file) do
        i = i + 1
        local success, result = self:run(line)

        if not success then
            return self:print(("error at line %d: %s"):format(i, result))
        end

        if result then
            self:print(result)
        end
    end
end

return Console
