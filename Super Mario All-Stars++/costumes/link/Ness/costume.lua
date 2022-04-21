local pm = require("playerManager")
local extrasounds = require("extrasounds")

local costume = {}

function costume.onInit(p)
	plr = p
	registerEvent(costume,"onInputUpdate")
	registerEvent(costume,"onTick")
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/link/Ness/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/link/Ness/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/link/Ness/block-hit.ogg")
	--extrasounds.id[4]  = Audio.SfxOpen("costumes/link/Ness/block-smash.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/link/Ness/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/link/Ness/player-grow.ogg")
	--extrasounds.id[7]  = Audio.SfxOpen("costumes/link/Ness/mushroom.ogg")
	extrasounds.id[8]  = Audio.SfxOpen("costumes/link/Ness/player-died.ogg")
	extrasounds.id[14] = Audio.SfxOpen("costumes/link/Ness/coin.ogg")
	extrasounds.id[15] = Audio.SfxOpen("costumes/link/Ness/1up.ogg")
	extrasounds.id[18] = Audio.SfxOpen("costumes/link/Ness/fireball.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("costumes/link/Ness/door.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/link/Ness/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/link/Ness/player-died2.ogg")
	Audio.sounds[77].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-stab.ogg")
	Audio.sounds[78].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-hurt.ogg")
	Audio.sounds[79].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-heart.ogg")
	Audio.sounds[80].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-died.ogg")
	Audio.sounds[81].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-rupee.ogg")
	Audio.sounds[82].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-fire.ogg")
	Audio.sounds[83].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-item.ogg")
	Audio.sounds[84].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-key.ogg")
	Audio.sounds[85].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-shield.ogg")
	Audio.sounds[86].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-dash.ogg")
	Audio.sounds[87].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-fairy.ogg")
	Audio.sounds[88].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-grass.ogg")
	Audio.sounds[89].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-hit.ogg")
	Audio.sounds[90].sfx = Audio.SfxOpen("costumes/link/Ness/zelda-sword-beam.ogg")
	
	Defines.player_walkspeed = 4
	Defines.player_runspeed = 4
	Defines.jumpheight = 21
	Defines.jumpheight_bounce = 20
	Defines.projectilespeedx = 7.0
	Defines.player_grav = 0.41
	
	costume.abilitesenabled = true
end

function costume.onInputUpdate()
	if SaveData.toggleCostumeAbilities == true then
		if player.keys.run == KEYS_DOWN then
			plr:mem(0x168, FIELD_FLOAT, 10)
		else
			plr:mem(0x168, FIELD_FLOAT, 0)
		end
	end
end

function costume.onCleanup(p)
	Audio.sounds[1].sfx  = nil	
	Audio.sounds[2].sfx  = nil
	Audio.sounds[3].sfx  = nil
	extrasounds.id[4]  = Audio.SfxOpen(Misc.resolveSoundFile("block-smash"))
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	extrasounds.id[7]  = Audio.SfxOpen(Misc.resolveSoundFile("mushroom"))
	extrasounds.id[8] = Audio.SfxOpen(Misc.resolveSoundFile("player-died"))
	Audio.sounds[9].sfx  = nil
	Audio.sounds[10].sfx = nil
	Audio.sounds[11].sfx = nil
	Audio.sounds[12].sfx = nil
	Audio.sounds[13].sfx = nil
	extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("coin"))
	extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("1up"))
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("fireball"))
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
	extrasounds.id[43] = Audio.SfxOpen(Misc.resolveSoundFile("fireworks"))
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
	extrasounds.id[59] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin"))
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
	extrasounds.id104 = Audio.SfxOpen(Misc.resolveSoundFile("sound/explode.ogg")) --SMB2 Explosion
	extrasounds.id105 = Audio.SfxOpen(Misc.resolveSoundFile("sound/hammerthrow.ogg")) --Player hammer throw
	extrasounds.id106 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo1.ogg")) --Shell hit 2
	extrasounds.id107 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo2.ogg")) --Shell hit 3
	extrasounds.id108 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo3.ogg")) --Shell hit 4
	extrasounds.id109 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo4.ogg")) --Shell hit 5
	extrasounds.id110 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo5.ogg")) --Shell hit 6
	extrasounds.id111 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo6.ogg")) --Shell hit 7
	extrasounds.id112 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo7.ogg")) --Shell hit 8
	
	
	Defines.jumpheight = 20
	Defines.player_walkspeed = 3
	Defines.player_runspeed = 6
	Defines.jumpheight_bounce = 32
	Defines.projectilespeedx = 7.1
	Defines.player_grav = 0.4
end

return costume