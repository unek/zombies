local AssetManager = Class("game.AssetManager")

function AssetManager:initialize(folder)
    self.folder = folder

    self.images = {}
    self.sounds = {}

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
        if love.filesystem.isFile(folder .. "/" .. filename) then
            local file, ext = filename:match("^(.*)%.(.-)$")
            local name, id  = file:match("^(.-)[_-]?(%d*)$")
            if ext == "png" or ext == "jpg" or ext == "bmp" then
                if id then
                    if not self.images[name] then self.images[name] = {} end
                    self.images[name][id] = love.graphics.newImage(folder .. "/" .. filename)
                else
                    self.images[file] = love.graphics.newImage(folder .. "/" .. filename)
                end
            end
        elseif love.filesystem.isDirectory(filename) then
            self:scanFolder(folder .. "/" .. filename)
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
        return (type(self.images[name]) == "table" and self.images[name][id]) and self.images[name][id] or self.images[name] or self._notexture
    end
end

function AssetManager:getRandomImage(name)
    return self:getImage(name, true)
end

return AssetManager
