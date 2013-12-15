local AnimatedSprite = Component:extend("AnimatedSprite")

function AnimatedSprite:initialize(image, framewidth, frameheight, delay, frames)
    self.width  = framewidth
    self.height = frameheight

    self.image  = assert(image:type() == "Image" and image, "first argument must be an image")
    self.quads  = {}

    for x = 0, self.image:getWidth() / self.width do
        for y = 0, self.image:getHeight() / self.height do
            local quad = love.graphics.newQuad(
              x * self.width, y * self.height
            , self.width, self.height
            , self.image:getWidth(), self.image:getHeight())

            table.insert(self.quads, quad)
        end
    end

    self.delay     = delay or 0.1
    self.frames    = frames or #self.quads
    self.frame     = 0
    self.timer     = 0
end

function AnimatedSprite:draw()
    local sx, sy = 1, 1
    love.graphics.draw(self.image, self.quads[self.frame + 1], self.pos.x, self.pos.y, self.rotation, sx, sy, (self.width/2)/sx, (self.height/2)/sy)
end

function AnimatedSprite:update(dt)
    self.timer = self.timer + dt
    if self.timer > self.delay then
        local i = math.floor(self.timer / self.delay)

        self.frame = (self.frame + i) % self.frames

        self.timer = 0
    end
end
