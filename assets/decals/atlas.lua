-- Generated with TexturePacker (http://www.codeandweb.com/texturepacker)
-- with a custom export by Stewart Bracken (http://stewart.bracken.bz)
--
-- $TexturePacker:SmartUpdate:1fe977fde9777cd0f7031af28eed50e5$
--
--[[------------------------------------------------------------------------
-- Example Usage --

function love.load()
	myAtlas = require("atlas")
	batch = love.graphics.newSpriteBatch( myAtlas.texture, 100, "stream" )
end
function love.draw()
	batch:clear()
	batch:bind()
		batch:add( myAtlas.quads['mySpriteName'], love.mouse.getX(), love.mouse.getY() )
	batch:unbind()
	love.graphics.draw(batch)
end

--]]------------------------------------------------------------------------

local TextureAtlas = {}
local Quads = {}
local Texture = love.graphics.newImage( "atlas.png" )

Quads["blood01"] = love.graphics.newQuad(1792, 1792, 256, 256, 2048, 2048 )
Quads["blood02"] = love.graphics.newQuad(1792, 1536, 256, 256, 2048, 2048 )
Quads["blood03"] = love.graphics.newQuad(1536, 1792, 256, 256, 2048, 2048 )
Quads["blood04"] = love.graphics.newQuad(1536, 1536, 256, 256, 2048, 2048 )
Quads["blood05"] = love.graphics.newQuad(1792, 1280, 256, 256, 2048, 2048 )
Quads["blood06"] = love.graphics.newQuad(1536, 1280, 256, 256, 2048, 2048 )
Quads["blood07"] = love.graphics.newQuad(1280, 1792, 256, 256, 2048, 2048 )
Quads["blood08"] = love.graphics.newQuad(1280, 1536, 256, 256, 2048, 2048 )
Quads["blood09"] = love.graphics.newQuad(1280, 1280, 256, 256, 2048, 2048 )
Quads["blood10"] = love.graphics.newQuad(1792, 1024, 256, 256, 2048, 2048 )
Quads["bullet-hole01"] = love.graphics.newQuad(1536, 1024, 256, 256, 2048, 2048 )
Quads["bullet-hole02"] = love.graphics.newQuad(1280, 1024, 256, 256, 2048, 2048 )
Quads["bullet-hole03"] = love.graphics.newQuad(1024, 1792, 256, 256, 2048, 2048 )
Quads["bullet-hole04"] = love.graphics.newQuad(1024, 1536, 256, 256, 2048, 2048 )
Quads["bullet-hole05"] = love.graphics.newQuad(1024, 1280, 256, 256, 2048, 2048 )
Quads["bullet-hole06"] = love.graphics.newQuad(1024, 1024, 256, 256, 2048, 2048 )
Quads["bullet-hole07"] = love.graphics.newQuad(1792, 768, 256, 256, 2048, 2048 )
Quads["bullet-hole08"] = love.graphics.newQuad(1536, 768, 256, 256, 2048, 2048 )
Quads["bullet-hole09"] = love.graphics.newQuad(1280, 768, 256, 256, 2048, 2048 )
Quads["bullet-hole10"] = love.graphics.newQuad(1024, 768, 256, 256, 2048, 2048 )
Quads["burnmark"] = love.graphics.newQuad(0, 0, 512, 512, 2048, 2048 )
Quads["crack01"] = love.graphics.newQuad(768, 1792, 256, 256, 2048, 2048 )
Quads["crack02"] = love.graphics.newQuad(768, 1536, 256, 256, 2048, 2048 )
Quads["crack03"] = love.graphics.newQuad(768, 1280, 256, 256, 2048, 2048 )
Quads["crack04"] = love.graphics.newQuad(768, 1024, 256, 256, 2048, 2048 )
Quads["crack05"] = love.graphics.newQuad(768, 768, 256, 256, 2048, 2048 )
Quads["crack06"] = love.graphics.newQuad(1792, 512, 256, 256, 2048, 2048 )
Quads["crack07"] = love.graphics.newQuad(1536, 512, 256, 256, 2048, 2048 )
Quads["crack08"] = love.graphics.newQuad(1280, 512, 256, 256, 2048, 2048 )
Quads["crack09"] = love.graphics.newQuad(1024, 512, 256, 256, 2048, 2048 )
Quads["crack10"] = love.graphics.newQuad(768, 512, 256, 256, 2048, 2048 )
Quads["damaged01"] = love.graphics.newQuad(512, 1792, 256, 256, 2048, 2048 )
Quads["damaged02"] = love.graphics.newQuad(512, 1536, 256, 256, 2048, 2048 )
Quads["damaged03"] = love.graphics.newQuad(512, 1280, 256, 256, 2048, 2048 )
Quads["damaged04"] = love.graphics.newQuad(512, 1024, 256, 256, 2048, 2048 )
Quads["damaged05"] = love.graphics.newQuad(512, 768, 256, 256, 2048, 2048 )
Quads["damaged06"] = love.graphics.newQuad(512, 512, 256, 256, 2048, 2048 )
Quads["damaged07"] = love.graphics.newQuad(1792, 256, 256, 256, 2048, 2048 )
Quads["damaged08"] = love.graphics.newQuad(1536, 256, 256, 256, 2048, 2048 )
Quads["damaged09"] = love.graphics.newQuad(1280, 256, 256, 256, 2048, 2048 )
Quads["damaged10"] = love.graphics.newQuad(1024, 256, 256, 256, 2048, 2048 )
Quads["dirt01"] = love.graphics.newQuad(768, 256, 256, 256, 2048, 2048 )
Quads["dirt02"] = love.graphics.newQuad(512, 256, 256, 256, 2048, 2048 )
Quads["dirt03"] = love.graphics.newQuad(1792, 0, 256, 256, 2048, 2048 )
Quads["dirt04"] = love.graphics.newQuad(1536, 0, 256, 256, 2048, 2048 )
Quads["dirt05"] = love.graphics.newQuad(1280, 0, 256, 256, 2048, 2048 )
Quads["dirt06"] = love.graphics.newQuad(1024, 0, 256, 256, 2048, 2048 )
Quads["dirt07"] = love.graphics.newQuad(768, 0, 256, 256, 2048, 2048 )
Quads["dirt08"] = love.graphics.newQuad(512, 0, 256, 256, 2048, 2048 )
Quads["dirt09"] = love.graphics.newQuad(256, 1792, 256, 256, 2048, 2048 )
Quads["dirt10"] = love.graphics.newQuad(256, 1536, 256, 256, 2048, 2048 )
Quads["scratch01"] = love.graphics.newQuad(256, 1280, 256, 256, 2048, 2048 )
Quads["scratch02"] = love.graphics.newQuad(256, 1024, 256, 256, 2048, 2048 )
Quads["scratch03"] = love.graphics.newQuad(256, 768, 256, 256, 2048, 2048 )
Quads["scratch04"] = love.graphics.newQuad(256, 512, 256, 256, 2048, 2048 )
Quads["scratch05"] = love.graphics.newQuad(0, 1792, 256, 256, 2048, 2048 )
Quads["scratch06"] = love.graphics.newQuad(0, 1536, 256, 256, 2048, 2048 )
Quads["scratch07"] = love.graphics.newQuad(0, 1280, 256, 256, 2048, 2048 )
Quads["scratch08"] = love.graphics.newQuad(0, 1024, 256, 256, 2048, 2048 )
Quads["scratch09"] = love.graphics.newQuad(0, 768, 256, 256, 2048, 2048 )
Quads["scratch10"] = love.graphics.newQuad(0, 512, 256, 256, 2048, 2048 )

function TextureAtlas:getDimensions(quadName)
	local quad = self.quads[quadName]
	if not quad then
		return nil 
	end
	local x, y, w, h = quad:getViewport()
    return w, h
end

TextureAtlas.quads = Quads
TextureAtlas.texture = Texture

return TextureAtlas
