local pm = require("playerManager")
local extrasounds = require("extrasounds")
local HUDOverride = require("hudoverridee")

local costume = {}

local eventsRegistered = false
local plr

function costume.onInit(p)
    plr = p
	registerEvent(costume,"onStart")
	registerEvent(costume,"onDraw")
	registerEvent(costume,"onPlayerHarm")
	registerEvent(costume,"onTick")
	registerEvent(costume,"onTickEnd")
	registerEvent(costume,"onCleanup")
	registerEvent(costume,"onInputUpdate")
	local icantswim = require("icantswim")
	Audio.sounds[1].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-jump.ogg")
	Audio.sounds[2].sfx  = Audio.SfxOpen("costumes/toad/Sonic/stomped.ogg")
	Audio.sounds[3].sfx  = Audio.SfxOpen("costumes/toad/Sonic/block-hit.ogg")
	Audio.sounds[5].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-shrink.ogg")
	Audio.sounds[6].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-grow.ogg")
	Audio.sounds[7].sfx  = Audio.SfxOpen("costumes/toad/Sonic/mushroom.ogg")
	Audio.sounds[8].sfx  = Audio.SfxOpen("costumes/toad/Sonic/player-died.ogg")
	Audio.sounds[9].sfx  = Audio.SfxOpen("costumes/toad/Sonic/shell-hit.ogg")
	Audio.sounds[10].sfx = Audio.SfxOpen("costumes/toad/Sonic/player-slide.ogg")
	extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/coin.ogg"))
	extrasounds.id[15] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/1up.ogg"))
	Audio.sounds[17].sfx = Audio.SfxOpen("costumes/toad/Sonic/warp.ogg")
	extrasounds.id[18] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/fireball.ogg"))
	Audio.sounds[23].sfx = Audio.SfxOpen("costumes/toad/Sonic/grab.ogg")
	Audio.sounds[24].sfx = Audio.SfxOpen("costumes/toad/Sonic/spring.ogg")
	Audio.sounds[29].sfx = Audio.SfxOpen("costumes/toad/Sonic/do.ogg")
	Audio.sounds[31].sfx = Audio.SfxOpen("costumes/toad/Sonic/key.ogg")
	Audio.sounds[32].sfx = Audio.SfxOpen("costumes/toad/Sonic/pswitch.ogg")
	Audio.sounds[33].sfx = Audio.SfxOpen("costumes/toad/Sonic/tail.ogg")
	Audio.sounds[52].sfx = Audio.SfxOpen("costumes/toad/Sonic/got-star.ogg")
	Audio.sounds[54].sfx = Audio.SfxOpen("costumes/toad/Sonic/player-died2.ogg")
	Audio.sounds[58].sfx = Audio.SfxOpen("costumes/toad/Sonic/smw-checkpoint.ogg")
	extrasounds.id[59] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/toad/Sonic/dragon-coin.ogg"))
	Audio.sounds[71].sfx = Audio.SfxOpen("costumes/toad/Sonic/climbing.ogg")
	Audio.sounds[72].sfx = Audio.SfxOpen("costumes/toad/Sonic/swim.ogg")
	Audio.sounds[73].sfx = Audio.SfxOpen("costumes/toad/Sonic/grab2.ogg")
	Audio.sounds[75].sfx = Audio.SfxOpen("costumes/toad/Sonic/smb2-throw.ogg")
	Audio.sounds[76].sfx = Audio.SfxOpen("costumes/toad/Sonic/smb2-hit.ogg")
	
	--Sonic settings! This is useful for accuracy.
	Defines.player_walkspeed = 9
	Defines.player_runspeed = 9
	Defines.jumpheight = 25
	Defines.jumpheight_bounce = 31
	Defines.projectilespeedx = 10
	Defines.player_grav = 0.5
	
	costume.abilitesenabled = true
	HUDOverride.visible.itembox = false
end

function costume.onTick()
	if costume.abilitesenabled == true then
		--plr.powerup = PLAYER_BIG
		player:mem(0x160, FIELD_WORD, 0) --Fireballs are now less delayed!

		if hit then
			hitTicks = hitTicks + 1

			plr.keys.left = false
			plr.keys.right = false
			plr.keys.up = false
			plr.keys.down = false
			plr.keys.jump = false
			plr.keys.altJump = false
			plr.keys.run = false
			plr.keys.altRun = false

			plr.x = plr.x + 4 * plr.direction

			if plr:isGroundTouching() and hitTicks > 5 or (plr:mem(0x148, FIELD_WORD) >= 2 or plr:mem(0x14C, FIELD_WORD) >= 2) then
				hit = false
				plr:mem(0x140, FIELD_WORD, 200)
				Defines.gravity = Defines.gravity * 2
			end
		end
	end
end

function costume.onDraw()
	if costume.abilitesenabled == true then
		if hit then
			plr.frame = 16
		end
	end
end

function costume.onPlayerHarm(e, p)
	if player.hasStarman == true or player.isMega == true then return end
	
	if player.hasStarman == false or player.isMega == false then
		if costume.abilitesenabled == true then
			if hit then
				e.cancelled = true
				return
			end
			
			
			if mem(0x00B2C5A8, FIELD_WORD) > 0 then
				e.cancelled = true
				hit = true
				hitTicks = 0
				plr.speedY = -8
				plr.speedX = 0
				Defines.gravity = Defines.gravity / 2
				SFX.play(5)
				mem(0x00B2C5A8, FIELD_WORD, 0)
				Effect.spawn(11, p.x, p.y)
			else
				p:kill()
			end
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
	Audio.sounds[8].sfx  = nil
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
	
	costume.abilitesenabled = false
	HUDOverride.visible.itembox = true
end

return costume