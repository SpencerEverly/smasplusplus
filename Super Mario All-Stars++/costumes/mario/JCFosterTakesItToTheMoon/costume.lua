local pm = require("playerManager")

local costume = {}

function costume.onInit(p)
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-jump.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-grow.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-died.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/mario/JCFosterTakesItToTheMoon/player-died2.ogg")
end

function costume.onCleanup(p)
	Audio.sounds[1].sfx  = nil
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	Audio.sounds[8].sfx  = nil
	Audio.sounds[52].sfx = nil
	Audio.sounds[54].sfx = nil
end

return costume;