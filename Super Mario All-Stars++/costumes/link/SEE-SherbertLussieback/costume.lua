local pm = require("playerManager")

local costume = {}

function costume.onInit(p)
	plr = p
	registerEvent(costume,"onInputUpdate")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/got-star.ogg")
	Audio.sounds[77].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-stab.ogg")
	Audio.sounds[78].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-hurt.ogg")
	Audio.sounds[79].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-heart.ogg")
	Audio.sounds[80].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-died.ogg")
	Audio.sounds[81].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-rupee.ogg")
	Audio.sounds[82].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-fire.ogg")
	Audio.sounds[83].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-item.ogg")
	Audio.sounds[84].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-key.ogg")
	Audio.sounds[85].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-shield.ogg")
	Audio.sounds[86].sfx = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
	Audio.sounds[87].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-fairy.ogg")
	Audio.sounds[88].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-grass.ogg")
	Audio.sounds[89].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-hit.ogg")
	Audio.sounds[90].sfx = Audio.SfxOpen("costumes/link/SEE-SherbertLussieback/zelda-sword-beam.ogg")
	
	Defines.player_walkspeed = 4
	Defines.player_runspeed = 5
	Defines.jumpheight = 25
	Defines.jumpheight_bounce = 25
	Defines.projectilespeedx = 7.0
	Defines.player_grav = 0.44
	
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
	Audio.sounds[79].sfx = nil
	Audio.sounds[80].sfx = nil
	Audio.sounds[81].sfx = nil
	Audio.sounds[82].sfx = nil
	Audio.sounds[91].sfx = nil
	
	Defines.jumpheight = 20
	Defines.player_walkspeed = 3
	Defines.player_runspeed = 6
	Defines.jumpheight_bounce = 32
	Defines.projectilespeedx = 7.1
	Defines.player_grav = 0.4
end

return costume;