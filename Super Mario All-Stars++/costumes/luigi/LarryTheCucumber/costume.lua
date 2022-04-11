local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

function costume.onInit(p)
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/player-jump.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/block-hit.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/player-grow.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/player-died.ogg")
	Audio.sounds[13].sfx = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/camera-change.ogg")
	Audio.sounds[23].sfx = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/grab.ogg")
	Audio.sounds[43].sfx = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/fireworks.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/door.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/got-star.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/grab2.ogg")
	Audio.sounds[75].sfx = Audio.SfxOpen("costumes/luigi/LarryTheCucumber/smb2-throw.ogg")
	
	Defines.player_walkspeed = 2.65
	Defines.player_runspeed = 6.1
	Defines.jumpheight = 12
	Defines.jumpheight_bounce = 29.4
	Defines.player_grav = 0.26
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
	extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("sound/coin.ogg"))
	extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("sound/1up.ogg"))
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("sound/fireball.ogg"))
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
	extrasounds.id92 = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg"))
	extrasounds.id93 = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg"))
	extrasounds.id94 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_freeze.ogg"))
	extrasounds.id95 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_icebreak.ogg"))
	extrasounds.id96 = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg"))
	extrasounds.id97 = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg"))
	extrasounds.id98 = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg"))
	extrasounds.id99 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg"))
	extrasounds.id100 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg"))
	extrasounds.id101 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg"))
	extrasounds.id102 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg"))
	extrasounds.id103 = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg"))
	
	Defines.jumpheight = 20
	Defines.player_walkspeed = 3
	Defines.player_runspeed = 6
	Defines.jumpheight_bounce = 32
	Defines.player_grav = 0.4
end

return costume;