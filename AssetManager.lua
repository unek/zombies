local AssetManager = Class("AssetManager")

function AssetManager:initialize(folder)
    self.folder = folder:gsub("/$", "")

    self.images = {}
    self.sounds = {}
    self.fonts  = {}

    self.loaded = 0
    self.total  = self:countFiles()

    local notexture = love.image.newImageData(15, 15)
    notexture:mapPixel(function(x, y, r, g, b, a)
        local i = x * notexture:getWidth() + y

        if i % 2 == 1 then
            return 255, 0, 255
        end
        return 0, 0, 0
    end)

    self._notexture = love.graphics.newImage(notexture)
    self._notexture:setFilter("nearest", "nearest")

    local font  = love.graphics.newFont(18)
    local texts = {"Infecting humans...", "Formatting your filesystem...", "Spinning up the hamster...", "Testing your patience..."}
    local text  = texts[math.random(1, #texts)]
    self.callback = function(file)
        love.graphics.clear()

        local w, h = love.graphics.getDimensions()

        local vertices = {}
        local amount   = self.loaded / self.total
        local segments = self.total
        local radius   = 10
        local color    = amount * 255

        local x = w - radius - font:getWidth(text) - 10
        local y = h - radius - 10

        for i = 0, math.floor(amount * segments) do
            local theta = (i / segments) * math.pi * 2
            table.insert(vertices, x + math.cos(theta) * radius)
            table.insert(vertices, y + math.sin(theta) * radius)
        end

        love.graphics.setColor(255 - color, color, 255, 200)
        love.graphics.setLineWidth(2)

        if #vertices >= 4 then
            love.graphics.line(unpack(vertices))
        end

        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(font)
        love.graphics.print(text, x + radius + 5, y - font:getHeight() / 2)

        love.graphics.present()
    end

    self:scanFolder(self.folder)
end

function AssetManager:countFiles(count, folder)
    local count  = count or 0
    local folder = folder or self.folder
    local items  = love.filesystem.getDirectoryItems(folder)

    for _, filename in pairs(items) do
        local path = folder .. "/" .. filename
        if love.filesystem.isFile(path) then
            count = count + 1
        else
            count = self:countFiles(count, path)
        end
    end

    return count
end

function AssetManager:scanFolder(folder)
    local items = love.filesystem.getDirectoryItems(folder)

    for _, filename in pairs(items) do
        local path = folder .. "/" .. filename
        if love.filesystem.isFile(path) then
            self.loaded = self.loaded + 1
            self.callback(path)

            local file, ext = filename:match("^(.*)%.(.-)$")
            local name, id  = file:match("^(.-)[_-]?(%d*)$")
            id = tonumber(id)
            if ext == "png" or ext == "jpg" or ext == "bmp" then
                local image = love.graphics.newImage(path)
                if id then
                    if not self.images[name] then self.images[name] = {} end
                    self.images[name][id] = image
                else
                    self.images[file] = image
                end
            elseif ext == "ttf" or ext == "otf" then
                local file = love.filesystem.newFileData(path)
                self.fonts[name] = {}
                setmetatable(self.fonts[name], {
                    __index = function(t, k)
                        if not rawget(self.fonts[name], k) then
                            rawset(self.fonts[name], k, love.graphics.newFont(file, k))
                        end

                        return rawget(self.fonts[name], k)
                    end,
                    __call = function(arg)
                        if not rawget(self.fonts[name], arg) then
                            rawset(self.fonts[name], arg, love.graphics.newFont(file, arg))
                        end

                        return rawget(self.fonts[name], arg)
                    end
                })
            elseif ext == "wav" or ext == "ogg" or ext == "mp3" then
                --local decoder     = love.audio.newDecoder(path)
                --self.sounds[name] = decoder
            end
        elseif love.filesystem.isDirectory(path) then
            self:scanFolder(path)
        end
    end
end

function AssetManager:getImage(name, random)
    local random = random or false
    if random then
        if type(self.images[name]) ~= "table" then
            return self.images[name] or self._notexture
        end
        local keys = {}
        for key in pairs(self.images[name]) do
            table.insert(keys, key)
        end

        return self.images[name][keys[math.random(1, #keys)]]
    else
        local name, id = name:match("^(.-)[_-]?(%d*)$")
        id = tonumber(id)
        return (type(self.images[name]) == "table" and self.images[name][id]) and self.images[name][id] or self.images[name] or self._notexture
    end
end

function AssetManager:getRandomImage(name)
    return self:getImage(name, true)
end

function AssetManager:getFont(name, size)
    local font = assert(self.fonts[name], "font doesn't exist")
    return size and font[size] or font
end

return AssetManager
