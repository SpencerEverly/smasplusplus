local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

function costume.onInit(p)
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/5-SMB2-SMAS/player-grow.ogg")
	extrasounds.id[8]  = Audio.SfxOpen("costumes/mario/5-SMB2-SMAS/player-died.ogg")
end

function costume.onCleanup(p)
	Audio.sounds[6].sfx  = nil
	extrasounds.id[8] = Audio.SfxOpen(Misc.resolveSoundFile("player-died"))
end

return costume