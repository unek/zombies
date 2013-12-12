local Camera = Class("Camera")
function Camera:initialize(x, y)
	self.pos	= {}
	self.pos.x	= x or 0
	self.pos.y	= y or 0
end
function Camera:lookAt(x, y)
	self.pos.x = x
	self.pos.y = y
end

function Camera:push()
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()

	love.graphics.push()
	love.graphics.translate(w / 2, h / 2)
	love.graphics.translate(-self.pos.x, -self.pos.y)
end

function Camera:pop()
	love.graphics.pop()
end
function Camera:mousePosition()
	return self:to_world(love.mouse.getPosition())
end
function Camera:toCamera(x, y)
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	local x = x - self.pos.x + w / 2
	local y = y - self.pos.y + h / 2

	return x, y
end
function Camera:toWorld(x, y)
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	local x = x - w / 2
	local y = y - h / 2

	return x + self.pos.x, y + self.pos.y
end
function Camera:getBounds()
	local w, h = love.graphics.getWidth(), love.graphics.getHeight()
	local x, y = self.pos.x, self.pos.y
	return x - w / 2, y - h / 2 , x + w / 2, y + h / 2
end

return Camera
