local pm = require("playerManager")
local Routine = require("routine")

local costume = {}

local eventsRegistered = false

function costume.onInit(p)
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/stomped.ogg")
	--Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/block-hit.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/player-grow.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/player-died.ogg")
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/shell-hit.ogg")
	--Audio.sounds[13].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/camera-change.ogg")
	Audio.sounds[14].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/coin.ogg")
	Audio.sounds[15].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/1up.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/warp.ogg")
	--Audio.sounds[23].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/grab.ogg")
	Audio.sounds[34].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/racoon.ogg")
	--Audio.sounds[43].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/fireworks.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/door.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/player-died2.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/swim.ogg")
	--Audio.sounds[73].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/grab2.ogg")
	--Audio.sounds[75].sfx = Audio.SfxOpen("costumes/luigi/Undertale-Frisk/smb2-throw.ogg")
	
	Defines.player_walkspeed = 4.0
	Defines.player_runspeed = 4.0
	Defines.jumpheight = 15
	Defines.jumpheight_bounce = 16
	Defines.player_grav = 0.35
	
	eventsRegistered = true
end

function costume.onCleanup(p)
	Audio.sounds[1].sfx  = nil	
	Audio.sounds[2].sfx  = nil
	Audio.sounds[3].sfx  = nil
	Audio.sounds[4].sfx  = nil
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	Audio.sounds[7].sfx  = nil
	Audio.sounds[8].sfx  = nil
	Audio.sounds[9].sfx  = nil
	Audio.sounds[10].sfx = nil
	Audio.sounds[11].sfx = nil
	Audio.sounds[12].sfx = nil
	Audio.sounds[13].sfx = nil
	Audio.sounds[14].sfx = nil
	Audio.sounds[15].sfx = nil
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	Audio.sounds[18].sfx = nil
	Audio.sounds[19].sfx = nil
	Audio.sounds[20].sfx = nil
	Audio.sounds[21].sfx = nil
	Audio.sounds[22].sfx = nil
	Audio.sounds[23].sfx = nil
	Audio.sounds[24].sfx = nil
	Audio.sounds[25].sfx = nil
	Audio.sounds[29].sfx = nil
	Audio.sounds[31].sfx = nil
	Audio.sounds[32].sfx = nil
	Audio.sounds[33].sfx = nil
	Audio.sounds[34].sfx = nil
	Audio.sounds[35].sfx = nil
	Audio.sounds[36].sfx = nil
	Audio.sounds[37].sfx = nil
	Audio.sounds[38].sfx = nil
	Audio.sounds[39].sfx = nil
	Audio.sounds[41].sfx = nil
	Audio.sounds[42].sfx = nil
	Audio.sounds[43].sfx = nil
	Audio.sounds[44].sfx = nil
	Audio.sounds[46].sfx = nil
	Audio.sounds[47].sfx = nil
	Audio.sounds[48].sfx = nil
	Audio.sounds[49].sfx = nil
	Audio.sounds[50].sfx = nil
	Audio.sounds[51].sfx = nil
	Audio.sounds[52].sfx = nil
	Audio.sounds[54].sfx = nil
	Audio.sounds[55].sfx = nil
	Audio.sounds[56].sfx = nil
	Audio.sounds[57].sfx = nil
	Audio.sounds[58].sfx = nil
	Audio.sounds[59].sfx = nil
	Audio.sounds[61].sfx = nil
	Audio.sounds[62].sfx = nil
	Audio.sounds[63].sfx = nil
	Audio.sounds[71].sfx = nil
	Audio.sounds[72].sfx = nil
	Audio.sounds[73].sfx = nil
	Audio.sounds[75].sfx = nil
	Audio.sounds[76].sfx = nil
	Audio.sounds[77].sfx = nil
	Audio.sounds[78].sfx = nil
	Audio.sounds[79].sfx = nil
	Audio.sounds[80].sfx = nil
	Audio.sounds[81].sfx = nil
	Audio.sounds[82].sfx = nil
	Audio.sounds[91].sfx = nil
	Defines.jumpheight = 20
	Defines.player_walkspeed = 3
	Defines.player_runspeed = 6
	Defines.jumpheight_bounce = 32
	Defines.player_grav = 0.4
end

return costume