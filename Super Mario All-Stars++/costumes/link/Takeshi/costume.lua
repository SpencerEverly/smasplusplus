local pm = require("playerManager")

local costume = {}

function costume.onInit(p)
	plr = p
	registerEvent(costume,"onInputUpdate")
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/link/Takeshi/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/link/Takeshi/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/link/Takeshi/block-hit.ogg")
	Audio.sounds[4].sfx  = Audio.SfxOpen("costumes/link/Takeshi/block-smash.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/link/Takeshi/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/link/Takeshi/player-grow.ogg")
	Audio.sounds[7].sfx  = Audio.SfxOpen("costumes/link/Takeshi/mushroom.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/link/Takeshi/player-died.ogg")
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/link/Takeshi/shell-hit.ogg")
	Audio.sounds[10].sfx = Audio.SfxOpen("costumes/link/Takeshi/player-slide.ogg")
	Audio.sounds[11].sfx = Audio.SfxOpen("costumes/link/Takeshi/item-dropped.ogg")
	Audio.sounds[12].sfx = Audio.SfxOpen("costumes/link/Takeshi/has-item.ogg")
	Audio.sounds[13].sfx = Audio.SfxOpen("costumes/link/Takeshi/camera-change.ogg")
	Audio.sounds[14].sfx = Audio.SfxOpen("costumes/link/Takeshi/coin.ogg")
	Audio.sounds[15].sfx = Audio.SfxOpen("costumes/link/Takeshi/1up.ogg")
	Audio.sounds[16].sfx = Audio.SfxOpen("costumes/link/Takeshi/lava.ogg")
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/link/Takeshi/warp.ogg")
	Audio.sounds[18].sfx = Audio.SfxOpen("costumes/link/Takeshi/fireball.ogg")
	Audio.sounds[19].sfx = Audio.SfxOpen("costumes/link/Takeshi/level-win.ogg")
	Audio.sounds[20].sfx = Audio.SfxOpen("costumes/link/Takeshi/boss-beat.ogg")
	Audio.sounds[21].sfx = Audio.SfxOpen("costumes/link/Takeshi/dungeon-win.ogg")
	Audio.sounds[22].sfx = Audio.SfxOpen("costumes/link/Takeshi/bullet-bill.ogg")
	Audio.sounds[23].sfx = Audio.SfxOpen("costumes/link/Takeshi/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("costumes/link/Takeshi/spring.ogg")
	Audio.sounds[25].sfx = Audio.SfxOpen("costumes/link/Takeshi/hammer.ogg")
	Audio.sounds[29].sfx = Audio.SfxOpen("costumes/link/Takeshi/do.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/link/Takeshi/key.ogg")
	Audio.sounds[32].sfx = Audio.SfxOpen("costumes/link/Takeshi/pswitch.ogg")
	Audio.sounds[33].sfx = Audio.SfxOpen("costumes/link/Takeshi/tail.ogg")
	Audio.sounds[34].sfx = Audio.SfxOpen("costumes/link/Takeshi/racoon.ogg")
	Audio.sounds[35].sfx = Audio.SfxOpen("costumes/link/Takeshi/boot.ogg")
	Audio.sounds[36].sfx = Audio.SfxOpen("costumes/link/Takeshi/smash.ogg")
	Audio.sounds[37].sfx = Audio.SfxOpen("costumes/link/Takeshi/thwomp.ogg")
	Audio.sounds[42].sfx = Audio.SfxOpen("costumes/link/Takeshi/npc-fireball.ogg")
	Audio.sounds[43].sfx = Audio.SfxOpen("costumes/link/Takeshi/fireworks.ogg")
	Audio.sounds[44].sfx = Audio.SfxOpen("costumes/link/Takeshi/bowser-killed.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("costumes/link/Takeshi/door.ogg")
	Audio.sounds[48].sfx = Audio.SfxOpen("costumes/link/Takeshi/yoshi.ogg")
	Audio.sounds[49].sfx = Audio.SfxOpen("costumes/link/Takeshi/yoshi-hurt.ogg")
	Audio.sounds[50].sfx = Audio.SfxOpen("costumes/link/Takeshi/yoshi-tongue.ogg")
	Audio.sounds[51].sfx = Audio.SfxOpen("costumes/link/Takeshi/yoshi-egg.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/link/Takeshi/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/link/Takeshi/player-died2.ogg")
	Audio.sounds[55].sfx = Audio.SfxOpen("costumes/link/Takeshi/yoshi-swallow.ogg")
	Audio.sounds[57].sfx = Audio.SfxOpen("costumes/link/Takeshi/dry-bones.ogg")
	Audio.sounds[58].sfx = Audio.SfxOpen("costumes/link/Takeshi/smw-checkpoint.ogg")
	Audio.sounds[59].sfx = Audio.SfxOpen("costumes/link/Takeshi/dragon-coin.ogg")
	Audio.sounds[61].sfx = Audio.SfxOpen("costumes/link/Takeshi/smw-blaarg.ogg")
	Audio.sounds[62].sfx = Audio.SfxOpen("costumes/link/Takeshi/wart-bubble.ogg")
	Audio.sounds[63].sfx = Audio.SfxOpen("costumes/link/Takeshi/wart-die.ogg")
	Audio.sounds[71].sfx = Audio.SfxOpen("costumes/link/Takeshi/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/link/Takeshi/swim.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("costumes/link/Takeshi/grab2.ogg")
	--Audio.sounds[74].sfx = Audio.SfxOpen("costumes/link/Takeshi/saw.ogg")
	Audio.sounds[75].sfx = Audio.SfxOpen("costumes/link/Takeshi/smb2-throw.ogg")
	Audio.sounds[76].sfx = Audio.SfxOpen("costumes/link/Takeshi/smb2-hit.ogg")
	Audio.sounds[77].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-stab.ogg")
	Audio.sounds[78].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-hurt.ogg")
	Audio.sounds[79].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-heart.ogg")
	Audio.sounds[80].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-died.ogg")
	Audio.sounds[81].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-rupee.ogg")
	Audio.sounds[82].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-fire.ogg")
	Audio.sounds[83].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-item.ogg")
	Audio.sounds[84].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-key.ogg")
	Audio.sounds[85].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-shield.ogg")
	Audio.sounds[86].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-dash.ogg")
	Audio.sounds[87].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-fairy.ogg")
	Audio.sounds[88].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-grass.ogg")
	Audio.sounds[89].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-hit.ogg")
	Audio.sounds[90].sfx = Audio.SfxOpen("costumes/link/Takeshi/zelda-sword-beam.ogg")
	Audio.sounds[91].sfx = Audio.SfxOpen("costumes/link/Takeshi/bubble.ogg")
	
	Defines.player_walkspeed = 3
	Defines.player_runspeed = 3
	Defines.jumpheight = 17
	Defines.jumpheight_bounce = 27
	Defines.projectilespeedx = 7.0
	Defines.player_grav = 0.3
	
	costume.abilitesenabled = true
end

function costume.onInputUpdate()
	if costume.abilitesenabled == true then
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
	Audio.sounds[83].sfx = nil
	Audio.sounds[84].sfx = nil
	Audio.sounds[85].sfx = nil
	Audio.sounds[86].sfx = nil
	Audio.sounds[87].sfx = nil
	Audio.sounds[88].sfx = nil
	Audio.sounds[89].sfx = nil
	Audio.sounds[90].sfx = nil
	Audio.sounds[91].sfx = nil
	
	
	Defines.jumpheight = 20
	Defines.player_walkspeed = 3
	Defines.player_runspeed = 6
	Defines.jumpheight_bounce = 32
	Defines.projectilespeedx = 7.1
	Defines.player_grav = 0.4
end

return costume