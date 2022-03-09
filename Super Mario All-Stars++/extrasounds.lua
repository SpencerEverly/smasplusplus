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
extrasounds.playersoundid1 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-jump.ogg"))
extrasounds.playersoundid2 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/stomped.ogg"))
extrasounds.playersoundid3 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/block-hit.ogg"))
extrasounds.playersoundid4 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/block-smash.ogg"))
extrasounds.playersoundid5 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-shrink.ogg"))
extrasounds.playersoundid6 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-grow.ogg"))
extrasounds.playersoundid7 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/mushroom.ogg"))
extrasounds.playersoundid8 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-died.ogg"))
extrasounds.playersoundid9 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/shell-hit.ogg"))
extrasounds.playersoundid10 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-slide.ogg"))
extrasounds.playersoundid11 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/item-dropped.ogg"))
extrasounds.playersoundid12 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/has-item.ogg"))
extrasounds.playersoundid13 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/camera-change.ogg"))
extrasounds.playersoundid14 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/coin.ogg"))
extrasounds.playersoundid15 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/1up.ogg"))
extrasounds.playersoundid16 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/lava.ogg"))
extrasounds.playersoundid17 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/warp.ogg"))
extrasounds.playersoundid18 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/fireball.ogg"))
extrasounds.playersoundid19 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/level-win.ogg"))
extrasounds.playersoundid20 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/boss-beat.ogg"))
extrasounds.playersoundid21 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dungeon-win.ogg"))
extrasounds.playersoundid22 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/bullet-bill.ogg"))
extrasounds.playersoundid23 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/grab.ogg"))
extrasounds.playersoundid24 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/spring.ogg"))
extrasounds.playersoundid25 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/hammer.ogg"))
extrasounds.playersoundid26 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/slide.ogg"))
extrasounds.playersoundid27 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/newpath.ogg"))
extrasounds.playersoundid28 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/level-select.ogg"))
extrasounds.playersoundid29 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/do.ogg"))
extrasounds.playersoundid30 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/pause.ogg"))
extrasounds.playersoundid31 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/key.ogg"))
extrasounds.playersoundid32 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/pswitch.ogg"))
extrasounds.playersoundid33 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/tail.ogg"))
extrasounds.playersoundid34 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/racoon.ogg"))
extrasounds.playersoundid35 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/boot.ogg"))
extrasounds.playersoundid36 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smash.ogg"))
extrasounds.playersoundid37 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/thwomp.ogg"))
extrasounds.playersoundid38 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-spit.ogg"))
extrasounds.playersoundid39 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-hit.ogg"))
extrasounds.playersoundid40 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-exit.ogg"))
extrasounds.playersoundid41 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/birdo-beat.ogg"))
extrasounds.playersoundid42 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/npc-fireball.ogg"))
extrasounds.playersoundid43 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/fireworks.ogg"))
extrasounds.playersoundid44 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/bowser-killed.ogg"))
extrasounds.playersoundid45 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/game-beat.ogg"))
extrasounds.playersoundid46 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/door.ogg"))
extrasounds.playersoundid47 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/message.ogg"))
extrasounds.playersoundid48 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi.ogg"))
extrasounds.playersoundid49 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-hurt.ogg"))
extrasounds.playersoundid50 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-tongue.ogg"))
extrasounds.playersoundid51 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-egg.ogg"))
extrasounds.playersoundid52 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/got-star.ogg"))
extrasounds.playersoundid53 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-kill.ogg"))
extrasounds.playersoundid54 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/player-died2.ogg"))
extrasounds.playersoundid55 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yoshi-swallow.ogg"))
extrasounds.playersoundid56 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/ring.ogg"))
extrasounds.playersoundid57 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dry-bones.ogg"))
extrasounds.playersoundid58 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-checkpoint.ogg"))
extrasounds.playersoundid59 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin.ogg"))
extrasounds.playersoundid60 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-exit.ogg"))
extrasounds.playersoundid61 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-blaarg.ogg"))
extrasounds.playersoundid62 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/wart-bubble.ogg"))
extrasounds.playersoundid63 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/wart-die.ogg"))
extrasounds.playersoundid64 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-block-hit.ogg"))
extrasounds.playersoundid65 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-killed.ogg"))
extrasounds.playersoundid66 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-hurt.ogg"))
extrasounds.playersoundid67 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-glass.ogg"))
extrasounds.playersoundid68 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-boss-hit.ogg"))
extrasounds.playersoundid69 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-cry.ogg"))
extrasounds.playersoundid70 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sm-explosion.ogg"))
extrasounds.playersoundid71 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/climbing.ogg"))
extrasounds.playersoundid72 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/swim.ogg"))
extrasounds.playersoundid73 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/grab2.ogg"))
extrasounds.playersoundid74 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smw-saw.ogg"))
extrasounds.playersoundid75 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-throw.ogg"))
extrasounds.playersoundid76 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/smb2-hit.ogg"))
extrasounds.playersoundid77 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-stab.ogg"))
extrasounds.playersoundid78 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-hurt.ogg"))
extrasounds.playersoundid79 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-heart.ogg"))
extrasounds.playersoundid80 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-died.ogg"))
extrasounds.playersoundid81 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-rupee.ogg"))
extrasounds.playersoundid82 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-fire.ogg"))
extrasounds.playersoundid83 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-item.ogg"))
extrasounds.playersoundid84 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-key.ogg"))
extrasounds.playersoundid85 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-shield.ogg"))
extrasounds.playersoundid86 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-dash.ogg"))
extrasounds.playersoundid87 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-fairy.ogg"))
extrasounds.playersoundid88 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-grass.ogg"))
extrasounds.playersoundid89 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-hit.ogg"))
extrasounds.playersoundid90 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/zelda-sword-beam.ogg"))
extrasounds.playersoundid92 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/sprout-vine.ogg"))
extrasounds.playersoundid93 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/iceball.ogg"))
extrasounds.playersoundid94 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yi_freeze.ogg"))
extrasounds.playersoundid95 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/yi_icebreak.ogg"))
extrasounds.playersoundid96 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/2up.ogg"))
extrasounds.playersoundid97 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/3up.ogg"))
extrasounds.playersoundid98 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/5up.ogg"))
extrasounds.playersoundid99 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get2.ogg"))
extrasounds.playersoundid100 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get3.ogg"))
extrasounds.playersoundid101 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get4.ogg"))
extrasounds.playersoundid102 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/dragon-coin-get5.ogg"))
extrasounds.playersoundid103 = Audio.SfxOpen(Misc.resolveSoundFile("_OST/_Sound Effects/player1/cherry.ogg"))

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

function extrasounds.onPostBlockHit(block, hitBlock, fromUpper, playerOrNil)
	local bricks = table.map{4,60,188,226}
	if not Misc.isPaused() then
		if block.contentID == nil then --Question Blocks, Special Blocks, etc.
			SFX.play(extrasounds.playersound0)
		end
		if block.contentID == 1225 then
			SFX.play(extrasounds.playersoundid92)
		elseif block.contentID == 1226 then
			SFX.play(extrasounds.playersoundid92)
		elseif block.contentID == 1227 then
			SFX.play(extrasounds.playersoundid92)
		elseif block.contentID == 0 then
			SFX.play(extrasounds.playersound0)
		elseif block.contentID == 1000 then
			SFX.play(extrasounds.playersound0)
		elseif block.contentID >= 1001 then
			SFX.play(extrasounds.playersoundid7)
		elseif block.contentID <= 99 then
			SFX.play(extrasounds.playersoundid14)
		end
		if block:mem(0x10, FIELD_STRING) then --Brick smashing
			if bricks[block.id] == (block.contentID >= 1) then
				SFX.play(extrasounds.playersound0)
			elseif bricks[block.id] then
				SFX.play(extrasounds.playersoundid4)
			end
		end
	end
end

function extrasounds.onInputUpdate()
	if not Misc.isPaused() then
		if player.rawKeys.run == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false and player:mem(0x12E, FIELD_BOOL) == false then
			if player.powerup == 3 then
				SFX.play(extrasounds.playersoundid18)
			end
			if player.powerup == 7 then
				SFX.play(extrasounds.playersoundid93)
			end
		end
	end
end

function extrasounds.onPostNPCKill(npc, harmtype)
	local starmans = table.map{994,996}
	local coins = table.map{10,33,88,103,138,258,528}
	local oneups = table.map{90,186,187}
	local threeups = table.map{188}
	if not Misc.isPaused() then
		if coins[npc.id] then
			SFX.play(extrasounds.playersoundid14)
		end
		if npc.id == 558 then
			SFX.play(extrasounds.playersoundid103)
		end
		if oneups[npc.id] then
			SFX.play(extrasounds.playersoundid15)
		end
		if npc.id == 188 then
			SFX.play(extrasounds.playersoundid97)
		end
		if npc.id == 274 then
			if NPC.config[npc.id].score == 6 then
				SFX.play(extrasounds.playersoundid59)
			elseif NPC.config[npc.id].score == 7 then
				SFX.play(extrasounds.playersoundid59)
			elseif NPC.config[npc.id].score == 8 then
				SFX.play(extrasounds.playersoundid99)
			elseif NPC.config[npc.id].score == 9 then
				SFX.play(extrasounds.playersoundid100)
			elseif NPC.config[npc.id].score == 10 then
				SFX.play(extrasounds.playersoundid101)
			elseif NPC.config[npc.id].score >= 11 then
				--Play 1UP sound as well
				SFX.play(extrasounds.playersoundid15)
				SFX.play(extrasounds.playersoundid102)
			end
		end
	end
end

return extrasounds