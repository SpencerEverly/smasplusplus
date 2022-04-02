local pm = require("playerManager")
local extrasounds = require("extrasounds")
local rng = require("base/rng")

local costume = {}

local killed = false

function costume.onInit(p)
	plr = p
	registerEvent(costume,"onStart")
	registerEvent(costume,"onPlayerKill")
	registerEvent(costume,"onPlayerHarm")
	registerEvent(costume,"onPostNPCKill")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/player-shrink.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/key.ogg")
	Audio.sounds[49].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/yoshi-hurt.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/mario/SP-1-EricCartman/got-star.ogg")
	Defines.player_walkspeed = 2
	Defines.player_runspeed = 5
	Defines.jumpheight = 17
	Defines.jumpheight_bounce = 22
end

function costume.onStart()
	if (Level.filename() == "SMAS - Start.lvlx") == false or (Level.filename() == "SMAS - Intro.lvlx") == false or (Level.filename() == "SMAS - Game Over.lvlx") == false or (Level.filename() == "SMAS - Map.lvlx") == false then
		SFX.play("costumes/mario/SP-1-EricCartman/voices/0005.ogg")
	end
end

function costume.onPostNPCKill(npc, harmType)
	local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
	local itemgetrng = rng.randomInt(1,7)
	if items[npc.id] and Colliders.collide(plr, npc) then
		SFX.play("costumes/mario/SP-1-EricCartman/voices/item/"..itemgetrng..".ogg", 1, 1, 80)
    end
end

function costume.onPlayerHarm()
	if not plr.hasStarman or plr.isMega then
		local hurtvoicerng = rng.randomInt(1,10)
		SFX.play("costumes/mario/SP-1-EricCartman/voices/hurt/"..hurtvoicerng..".ogg")
	end
end

function costume.onPlayerKill()
	local dyingvoicerng = rng.randomInt(1,10)
	SFX.play("costumes/mario/SP-1-EricCartman/voices/dying/"..dyingvoicerng..".ogg")
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
	extrasounds.id14 = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
	extrasounds.id15 = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	extrasounds.id18 = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
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

return costume