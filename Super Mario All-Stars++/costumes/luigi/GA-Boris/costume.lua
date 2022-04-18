local playerManager = require("playerManager")
local extrasounds = require("extrasounds")
local HUDOverride = require("hudoverridee")
local rng = require("base/rng")

local costume = {}

local eventsRegistered = false
local plr
local borishp
local hit = false

function costume.onInit(p)
	plr = p
	registerEvent(costume,"onTick")
	registerEvent(costume,"onTickEnd")
	registerEvent(costume,"onDraw")
	registerEvent(costume,"onPostPlayerHarm")
	registerEvent(costume,"onPlayerKill")
	registerEvent(costume,"onPostNPCKill")
	
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/stomped.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-grow.ogg")
	extrasounds.id[8]  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-died.ogg")
	Audio.sounds[10].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/player-slide.ogg")
	extrasounds.id[14]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/luigi/GA-Boris/coin.ogg"))
	extrasounds.id[18]  = Audio.SfxOpen(Misc.resolveSoundFile("costumes/luigi/GA-Boris/fireball.ogg"))
	Audio.sounds[21].sfx  = Audio.SfxOpen("costumes/luigi/GA-Boris/dungeon-win.ogg")
	Audio.sounds[23].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/grab.ogg")
	Audio.sounds[33].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/tail.ogg")
	Audio.sounds[34].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/racoon.ogg")
	extrasounds.id[43] = Audio.SfxOpen("costumes/luigi/GA-Boris/fireworks.ogg")
	Audio.sounds[46].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/door.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/player-died2.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/grab2.ogg")
	Audio.sounds[75].sfx = Audio.SfxOpen("costumes/luigi/GA-Boris/smb2-throw.ogg")
	
	costume.abilitiesenabled = true
	HUDOverride.visible.itembox = false
	borishp = 3
end

function costume.onPostNPCKill(npc, harmType)
	local items = table.map{9,184,185,249,14,182,183,34,169,170,277,264,996,994}
	if SaveData.toggleCostumeProfanity then
		local rngkey = rng.randomInt(1,6)
		if items[npc.id] and Colliders.collide(plr, npc) then
			playSound("luigi/GA-Boris/voices/items/"..rngkey..".ogg", 1, 1, 80)
		end
	else
		local rngkey = rng.randomInt(3,6)
		if items[npc.id] and Colliders.collide(plr, npc) then
			playSound("luigi/GA-Boris/voices/items/"..rngkey..".ogg", 1, 1, 80)
		end
	end
	if items[npc.id] and Colliders.collide(plr, npc) then
		borishp = borishp + 1
		if borishp > 3 then
			borishp = 3
		end
	end
end

function costume.onTick(p)
	local shootingPowerups = table.map{PLAYER_FIREFLOWER,PLAYER_ICE,PLAYER_HAMMER}
	local isShooting = (plr:mem(0x118,FIELD_FLOAT) >= 100 and plr:mem(0x118,FIELD_FLOAT) <= 118 and shootingPowerups[player.powerup])
	if costume.abilitiesenabled == true and SaveData.toggleCostumeAbilities == true then
		--Health system
		if plr.powerup <= 1 then
			plr.powerup = 2
		end
		
		
		
		--Switching frames when shooting fireballs as Boris
		if isShooting then
			plr:setFrame(27)
		end
		
		
		
		--Boris HP Hover System
		local heartfull3 = Graphics.loadImageResolved("costumes/luigi/GA-Boris/heart.png")
		if borishp <= 0 then
			
		end
		if borishp == 1 then
			Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
		end
		if borishp == 2 then
			Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
			Graphics.drawImageWP(heartfull3, player.x - camera.x,  player.y - camera.y - 55, -24)
		end
		if borishp >= 3 then
			Graphics.drawImageWP(heartfull3, player.x - camera.x - 28,  player.y - camera.y - 55, -24)
			Graphics.drawImageWP(heartfull3, player.x - camera.x,  player.y - camera.y - 55, -24)
			Graphics.drawImageWP(heartfull3, player.x - camera.x + 28,  player.y - camera.y - 55, -24)
		end
	end
end

function costume.onPostPlayerHarm()
	if costume.abilitiesenabled == true and SaveData.toggleCostumeAbilities == true then
		hit = true
		if hit then
			borishp = borishp - 1
		end
		if borishp < 1 then
			player:kill()
		end
	end
end

function costume.onCleanup(p)
	Audio.sounds[1].sfx  = nil	
	Audio.sounds[2].sfx  = nil
	Audio.sounds[3].sfx  = nil
	extrasounds.id[4]  = Audio.SfxOpen(Misc.resolveSoundFile("block-smash.ogg"))
	Audio.sounds[5].sfx  = nil
	Audio.sounds[6].sfx  = nil
	extrasounds.id[7]  = Audio.SfxOpen(Misc.resolveSoundFile("mushroom.ogg"))
	extrasounds.id[8] = Audio.SfxOpen(Misc.resolveSoundFile("player-died"))
	Audio.sounds[9].sfx  = nil
	Audio.sounds[10].sfx = nil
	Audio.sounds[11].sfx = nil
	Audio.sounds[12].sfx = nil
	Audio.sounds[13].sfx = nil
	extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
	extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
	Audio.sounds[16].sfx = nil
	Audio.sounds[17].sfx = nil
	extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
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
	extrasounds.id[43] = Audio.SfxOpen(Misc.resolveSoundFile("fireworks.ogg"))
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
	extrasounds.id[59] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin.ogg"))
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
	extrasounds.id[92] = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg"))
	extrasounds.id[93] = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg"))
	extrasounds.id[94] = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_freeze.ogg"))
	extrasounds.id[95] = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_icebreak.ogg"))
	extrasounds.id[96] = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg"))
	extrasounds.id[97] = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg"))
	extrasounds.id[98] = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg"))
	extrasounds.id[99] = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg"))
	extrasounds.id[100] = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg"))
	extrasounds.id[101] = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg"))
	extrasounds.id[102] = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg"))
	extrasounds.id[103] = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg"))
	extrasounds.id[104] = Audio.SfxOpen(Misc.resolveSoundFile("sound/explode.ogg")) --SMB2 Explosion
	extrasounds.id[105] = Audio.SfxOpen(Misc.resolveSoundFile("sound/hammerthrow.ogg")) --Player hammer throw
	extrasounds.id[106] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo1.ogg")) --Shell hit 2
	extrasounds.id[107] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo2.ogg")) --Shell hit 3
	extrasounds.id[108] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo3.ogg")) --Shell hit 4
	extrasounds.id[109] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo4.ogg")) --Shell hit 5
	extrasounds.id[110] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo5.ogg")) --Shell hit 6
	extrasounds.id[111] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo6.ogg")) --Shell hit 7
	extrasounds.id[112] = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo7.ogg")) --Shell hit 8
	costume.abilitiesenabled = false
	HUDOverride.visible.itembox = true
end

return costume