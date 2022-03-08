local extrasounds = {}

local ready = false

local climbsfxtimer = 1

local pipecounter = 1
local doorcounter = 1
local slidecounter = 1
local swallowcounter = 1
local pipecounter2 = 1
local doorcounter2 = 1
local slidecounter2 = 1
local swallowcounter2 = 1

extrasounds.playersound0 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/nothing.ogg")) --General sound to mute anything, really

local path = "_OST/_Sound Effects/player"
extrasounds.sounds = {}
for i=1, 2 do -- player indices
	extrasounds.sounds[i] = {
		playerJump = Misc.resolveSoundFile(path .. i .. "/player-jump"),
		stomped = Misc.resolveSoundFile(path .. i .. "/stomped"),
		blockHit = Misc.resolveSoundFile(path .. i .. "/block-hit"),
		blockSmash = Misc.resolveSoundFile(path .. i .. "/block-smash"),
		playerShrink = Misc.resolveSoundFile(path .. i .. "/player-shrink"),
		playerGrow = Misc.resolveSoundFile(path .. i .. "/player-grow"),
		mushroom = Misc.resolveSoundFile(path .. i .. "/mushroom")
	}
end

--Player(1)
extrasounds.playeronesound1 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-jump.ogg"))
extrasounds.playeronesound2 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/stomped.ogg"))
extrasounds.playeronesound3 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/block-hit.ogg"))
extrasounds.playeronesound4 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/block-smash.ogg"))
extrasounds.playeronesound5 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-shrink.ogg"))
extrasounds.playeronesound6 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-grow.ogg"))
extrasounds.playeronesound7 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/mushroom.ogg"))
extrasounds.playeronesound8 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-died.ogg"))
extrasounds.playeronesound9 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/shell-hit.ogg"))
extrasounds.playeronesound10 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-slide.ogg"))
extrasounds.playeronesound11 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/item-dropped.ogg"))
extrasounds.playeronesound12 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/has-item.ogg"))
extrasounds.playeronesound13 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/camera-change.ogg"))
extrasounds.playeronesound14 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/coin.ogg"))
extrasounds.playeronesound15 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/1up.ogg"))
extrasounds.playeronesound16 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/lava.ogg"))
extrasounds.playeronesound17 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/warp.ogg"))
extrasounds.playeronesound18 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/fireball.ogg"))
extrasounds.playeronesound19 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/level-win.ogg"))
extrasounds.playeronesound20 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/boss-beat.ogg"))
extrasounds.playeronesound21 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dungeon-win.ogg"))
extrasounds.playeronesound22 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/bullet-bill.ogg"))
extrasounds.playeronesound23 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/grab.ogg"))
extrasounds.playeronesound24 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/spring.ogg"))
extrasounds.playeronesound25 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/hammer.ogg"))
extrasounds.playeronesound26 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/slide.ogg"))
extrasounds.playeronesound27 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/newpath.ogg"))
extrasounds.playeronesound28 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/level-select.ogg"))
extrasounds.playeronesound29 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/do.ogg"))
extrasounds.playeronesound30 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/pause.ogg"))
extrasounds.playeronesound31 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/key.ogg"))
extrasounds.playeronesound32 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/pswitch.ogg"))
extrasounds.playeronesound33 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/tail.ogg"))
extrasounds.playeronesound34 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/racoon.ogg"))
extrasounds.playeronesound35 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/boot.ogg"))
extrasounds.playeronesound36 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smash.ogg"))
extrasounds.playeronesound37 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/thwomp.ogg"))
extrasounds.playeronesound38 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-spit.ogg"))
extrasounds.playeronesound39 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-hit.ogg"))
extrasounds.playeronesound40 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-exit.ogg"))
extrasounds.playeronesound41 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-beat.ogg"))
extrasounds.playeronesound42 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/npc-fireball.ogg"))
extrasounds.playeronesound43 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/fireworks.ogg"))
extrasounds.playeronesound44 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/bowser-killed.ogg"))
extrasounds.playeronesound45 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/game-beat.ogg"))
extrasounds.playeronesound46 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/door.ogg"))
extrasounds.playeronesound47 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/message.ogg"))
extrasounds.playeronesound48 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi.ogg"))
extrasounds.playeronesound49 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-hurt.ogg"))
extrasounds.playeronesound50 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-tongue.ogg"))
extrasounds.playeronesound51 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-egg.ogg"))
extrasounds.playeronesound52 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/got-star.ogg"))
extrasounds.playeronesound53 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-kill.ogg"))
extrasounds.playeronesound54 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-died2.ogg"))
extrasounds.playeronesound55 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-swallow.ogg"))
extrasounds.playeronesound56 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/ring.ogg"))
extrasounds.playeronesound57 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dry-bones.ogg"))
extrasounds.playeronesound58 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-checkpoint.ogg"))
extrasounds.playeronesound59 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin.ogg"))
extrasounds.playeronesound60 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-exit.ogg"))
extrasounds.playeronesound61 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-blaarg.ogg"))
extrasounds.playeronesound62 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/wart-bubble.ogg"))
extrasounds.playeronesound63 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/wart-die.ogg"))
extrasounds.playeronesound64 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-block-hit.ogg"))
extrasounds.playeronesound65 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-killed.ogg"))
extrasounds.playeronesound66 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-hurt.ogg"))
extrasounds.playeronesound67 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-glass.ogg"))
extrasounds.playeronesound68 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-boss-hit.ogg"))
extrasounds.playeronesound69 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-cry.ogg"))
extrasounds.playeronesound70 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-explosion.ogg"))
extrasounds.playeronesound71 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/climbing.ogg"))
extrasounds.playeronesound72 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/swim.ogg"))
extrasounds.playeronesound73 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/grab2.ogg"))
extrasounds.playeronesound74 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-saw.ogg"))
extrasounds.playeronesound75 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-throw.ogg"))
extrasounds.playeronesound76 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-hit.ogg"))
extrasounds.playeronesound77 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-stab.ogg"))
extrasounds.playeronesound78 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-hurt.ogg"))
extrasounds.playeronesound79 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-heart.ogg"))
extrasounds.playeronesound80 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-died.ogg"))
extrasounds.playeronesound81 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-rupee.ogg"))
extrasounds.playeronesound82 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-fire.ogg"))
extrasounds.playeronesound83 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-item.ogg"))
extrasounds.playeronesound84 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-key.ogg"))
extrasounds.playeronesound85 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-shield.ogg"))
extrasounds.playeronesound86 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-dash.ogg"))
extrasounds.playeronesound87 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-fairy.ogg"))
extrasounds.playeronesound88 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-grass.ogg"))
extrasounds.playeronesound89 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-hit.ogg"))
extrasounds.playeronesound90 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-sword-beam.ogg"))
extrasounds.playeronesound92 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sprout-vine.ogg"))
extrasounds.playeronesound93 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/iceball.ogg"))
extrasounds.playeronesound94 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yi_freeze.ogg"))
extrasounds.playeronesound95 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yi_icebreak.ogg"))
extrasounds.playeronesound96 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/2up.ogg"))
extrasounds.playeronesound97 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/3up.ogg"))
extrasounds.playeronesound98 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/5up.ogg"))
extrasounds.playeronesound99 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get2.ogg"))
extrasounds.playeronesound100 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get3.ogg"))
extrasounds.playeronesound101 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get4.ogg"))
extrasounds.playeronesound102 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get5.ogg"))
extrasounds.playeronesound103 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/cherry.ogg"))

function extrasounds.onInitAPI()
	registerEvent(extrasounds, "onKeyboardPress")
	registerEvent(extrasounds, "onDraw")
	registerEvent(extrasounds, "onLevelExit")
	registerEvent(extrasounds, "onTick")
	registerEvent(extrasounds, "onTickEnd")
	registerEvent(extrasounds, "onInputUpdate")
	registerEvent(extrasounds, "onStart")
	registerEvent(extrasounds, "onPostNPCKill")
	registerEvent(extrasounds, "onPostNPCHarm")
	registerEvent(extrasounds, "onPostPlayerHarm")
	registerEvent(extrasounds, "onPostPlayerKill")
	registerEvent(extrasounds, "onPostExplosion")
	registerEvent(extrasounds, "onPostBlockHit")
	
	local Routine = require("routine")
	
	ready = true
end

function extrasounds.onTick()
	Audio.sounds[4].muted = true
	Audio.sounds[7].muted = true
	Audio.sounds[14].muted = true
	Audio.sounds[15].muted = true
	Audio.sounds[18].muted = true
	Audio.sounds[59].muted = true
	
end

function extrasounds.onPostBlockHit(block, fromUpper, playerOrNil)
	local bricks = table.map{4,60,188,226}
	if not Misc.isPaused() then
		if Player(1) then
			if block.contentID == nil then --Question Blocks, Special Blocks, etc.
				SFX.play(extrasounds.playersound0)
			end
			if block.contentID == 1225 then
				SFX.play(extrasounds.playeronesound92)
			elseif block.contentID == 1226 then
				SFX.play(extrasounds.playeronesound92)
			elseif block.contentID == 1227 then
				SFX.play(extrasounds.playeronesound92)
			elseif block.contentID == 0 then
				SFX.play(extrasounds.playersound0)
			elseif block.contentID == 1000 then
				SFX.play(extrasounds.playersound0)
			elseif block.contentID >= 1001 then
				SFX.play(extrasounds.playeronesound7)
			elseif block.contentID <= 99 then
				SFX.play(extrasounds.playeronesound14)
			end
			if block:mem(0x10, FIELD_STRING) then --Bricks
				if bricks[block.id] == (block.contentID >= 1) then
					SFX.play(extrasounds.playersound0)
				elseif bricks[block.id] then
					SFX.play(extrasounds.playeronesound4)
				end
			end
		end
	end
end

function extrasounds.onInputUpdate()
	if not Misc.isPaused() then
		if player.rawKeys.run == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false then
			if player.powerup == 3 then
				SFX.play(extrasounds.playeronesound18)
			end
			if player.powerup == 7 then
				SFX.play(extrasounds.playeronesound93)
			end
		end
	end
end

function extrasounds.onPostNPCKill(npc, harmtype)
	local starmans = table.map{994,996}
	local coins = table.map{10,33,88,103,258,528}
	local oneups = table.map{90,186,187}
	local threeups = table.map{188}
	if Player(1) then
		if not Misc.isPaused() then
			if coins[npc.id] then
				SFX.play(extrasounds.playeronesound14)
			end
			if npc.id == 558 then
				SFX.play(extrasounds.playeronesound103)
			end
			if oneups[npc.id] then
				SFX.play(extrasounds.playeronesound15)
			end
			if npc.id == 188 then
				SFX.play(extrasounds.playeronesound97)
			end
			if npc.id == 274 then
				if NPC.config[npc.id].score == 6 then
					SFX.play(extrasounds.playeronesound59)
				elseif NPC.config[npc.id].score == 7 then
					SFX.play(extrasounds.playeronesound59)
				elseif NPC.config[npc.id].score == 8 then
					SFX.play(extrasounds.playeronesound99)
				elseif NPC.config[npc.id].score == 9 then
					SFX.play(extrasounds.playeronesound100)
				elseif NPC.config[npc.id].score == 10 then
					SFX.play(extrasounds.playeronesound101)
				elseif NPC.config[npc.id].score >= 11 then
					--Play 1UP sound as well
					SFX.play(extrasounds.playeronesound102)
					SFX.play(extrasounds.playeronesound15)
				end
			end
		end
	end
end

return extrasounds