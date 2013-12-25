local AssetManager = Class("game.AssetManager")

function AssetManager:initialize(folder)
    self.folder = folder

    self.images = {}
    self.sounds = {}
    self.fonts  = {}

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

    self:scanFolder(self.folder)
end

function AssetManager:scanFolder(folder)
    local items = love.filesystem.getDirectoryItems(folder)

    for _, filename in pairs(items) do
        local path = folder .. "/" .. filename
        if love.filesystem.isFile(path) then
            local file, ext = filename:match("^(.*)%.(.-)$")
            local name, id  = file:match("^(.-)[_-]?(%d*)$")
            id = tonumber(id)
            if ext == "png" or ext == "jpg" or ext == "bmp" then
                if id then
                    if not self.images[name] then self.images[name] = {} end
                    self.images[name][id] = love.graphics.newImage(path)
                else
                    self.images[file] = love.graphics.newImage(path)
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
                    end
                })
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
    return assert(self.fonts[name], "font doesn't exist")
end

return AssetManager
