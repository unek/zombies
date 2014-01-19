SoundManager = Class("SoundManager")

function SoundManager:initialize(world_scale)
	self.scale = world_scale

	self.music_volume   = 1.0
	self.effects_volume = 1.0

	self.sources = {}
	self.sources.streaming = {}
	self.sources.static    = {}
end

function SoundManager:setMusicVolume()

end

function SoundManager:setEffectsVolume()

end

function SoundManager:playSound(x, y, sound)

end
