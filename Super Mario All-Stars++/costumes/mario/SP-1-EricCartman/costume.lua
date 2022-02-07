local pm = require("playerManager")

local costume = {}

function costume.onInit(p)
	registerEvent(costume,"onStart")
	--Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-jump.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-grow.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-died.ogg")
	Audio.sounds[15].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/1up.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/key.ogg")
	Audio.sounds[34].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/racoon.ogg")
	--Audio.sounds[48].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/yoshi.ogg")
	Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/yoshi-hurt.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/got-star.ogg")
	Defines.player_walkspeed = 2
	Defines.player_runspeed = 5
	Defines.jumpheight = 17
	Defines.jumpheight_bounce = 22
end

function costume.onStart()
	if not levelname == "SMAS - Start.lvlx" or not "SMAS - Intro.lvlx" or not "SMAS - Game Over.lvlx" or not "SMAS - DLC World.lvlx" then
		Audio.playSFX("costumes/mario/SP-1-EricCartman/cartman-respectmyauthority.ogg")
	end
end

function costume.onCleanup(p)
	Audio.sounds[1].sfx  = nil
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	Audio.sounds[8].sfx  = nil
	Audio.sounds[15].sfx = nil
	Audio.sounds[31].sfx = nil
	Audio.sounds[34].sfx = nil
	Audio.sounds[52].sfx = nil
	Defines.jumpheight = 20
	Defines.player_walkspeed = 3
	Defines.player_runspeed = 6
	Defines.jumpheight_bounce = 32
	Defines.player_grav = 0.4
end

return costume