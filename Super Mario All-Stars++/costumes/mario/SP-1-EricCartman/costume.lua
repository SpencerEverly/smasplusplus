local pm = require("playerManager")

local costume = {}

function costume.onInit(p)
	registerEvent(costume,"onStart")
	--Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-jump.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-grow.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-died.ogg")
	extrasounds.playersoundid15 = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/1up.ogg")
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
	if (Level.filename() == "SMAS - Start.lvlx") == false or (Level.filename() == "SMAS - Intro.lvlx") == false or (Level.filename() == "SMAS - Game Over.lvlx") == false or (Level.filename() == "SMAS - DLC World.lvlx") == false then
		SFX.play("costumes/mario/SP-1-EricCartman/cartman-respectmyauthority.ogg")
	end
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
	extrasounds.playersoundid14 = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
	extrasounds.playersoundid15 = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	extrasounds.playersoundid18 = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
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
	extrasounds.playersoundid92 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/sprout-vine.ogg"))
	extrasounds.playersoundid93 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/iceball.ogg"))
	extrasounds.playersoundid94 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/yi_freeze.ogg"))
	extrasounds.playersoundid95 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/yi_icebreak.ogg"))
	extrasounds.playersoundid96 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/2up.ogg"))
	extrasounds.playersoundid97 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/3up.ogg"))
	extrasounds.playersoundid98 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/5up.ogg"))
	extrasounds.playersoundid99 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/dragon-coin-get2.ogg"))
	extrasounds.playersoundid100 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/dragon-coin-get3.ogg"))
	extrasounds.playersoundid101 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/dragon-coin-get4.ogg"))
	extrasounds.playersoundid102 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/dragon-coin-get5.ogg"))
	extrasounds.playersoundid103 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/cherry.ogg"))
	Defines.jumpheight = 20
	Defines.player_walkspeed = 3
	Defines.player_runspeed = 6
	Defines.jumpheight_bounce = 32
	Defines.player_grav = 0.4
end

return costume