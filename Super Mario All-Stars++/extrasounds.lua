--extrasounds.lua by Spencer Everly
--
--To have costume compability, require this library with playermanager on any/all costumes you're using, then replace sound slot IDs 4,7,14,15,18,59 from (example):
--
--Audio.sounds[14].sfx = Audio.SfxOpen("costumes/(character)/(costume)/coin.ogg")
--to
--extrasounds.playersoundid14 = Audio.SfxOpen(Misc.resolveSoundFile("costumes/(character)/(costume)/coin.ogg"))
--
--Check the lua file for info on which things does what

local extrasounds = {}

extrasounds.active = true --Are the extra sounds active? If not, they won't play. If false the library won't be used and will revert to the stock sound system. Useful for muting all sounds for a boot menu, cutscene, or something like that by using Audio.sounds[id].muted = true instead.

local ready = false --This library isn't ready until onInit is finished

extrasounds.playersoundid0 = Audio.SfxOpen(Misc.resolveSoundFile("sounds/nothing.ogg")) --General sound to mute anything, really

--Stock SMBX Sounds
extrasounds.playersoundid1 = Audio.SfxOpen(Misc.resolveSoundFile("player-jump.ogg"))
extrasounds.playersoundid2 = Audio.SfxOpen(Misc.resolveSoundFile("stomped.ogg"))
extrasounds.playersoundid3 = Audio.SfxOpen(Misc.resolveSoundFile("block-hit.ogg"))
extrasounds.playersoundid4 = Audio.SfxOpen(Misc.resolveSoundFile("block-smash.ogg"))
extrasounds.playersoundid5 = Audio.SfxOpen(Misc.resolveSoundFile("player-shrink.ogg"))
extrasounds.playersoundid6 = Audio.SfxOpen(Misc.resolveSoundFile("player-grow.ogg"))
extrasounds.playersoundid7 = Audio.SfxOpen(Misc.resolveSoundFile("mushroom.ogg"))
extrasounds.playersoundid8 = Audio.SfxOpen(Misc.resolveSoundFile("player-died.ogg"))
extrasounds.playersoundid9 = Audio.SfxOpen(Misc.resolveSoundFile("shell-hit.ogg"))
extrasounds.playersoundid10 = Audio.SfxOpen(Misc.resolveSoundFile("player-slide.ogg"))
extrasounds.playersoundid11 = Audio.SfxOpen(Misc.resolveSoundFile("item-dropped.ogg"))
extrasounds.playersoundid12 = Audio.SfxOpen(Misc.resolveSoundFile("has-item.ogg"))
extrasounds.playersoundid13 = Audio.SfxOpen(Misc.resolveSoundFile("camera-change.ogg"))
extrasounds.playersoundid14 = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
extrasounds.playersoundid15 = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
extrasounds.playersoundid16 = Audio.SfxOpen(Misc.resolveSoundFile("lava.ogg"))
extrasounds.playersoundid17 = Audio.SfxOpen(Misc.resolveSoundFile("warp.ogg"))
extrasounds.playersoundid18 = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
extrasounds.playersoundid19 = Audio.SfxOpen(Misc.resolveSoundFile("level-win.ogg"))
extrasounds.playersoundid20 = Audio.SfxOpen(Misc.resolveSoundFile("boss-beat.ogg"))
extrasounds.playersoundid21 = Audio.SfxOpen(Misc.resolveSoundFile("dungeon-win.ogg"))
extrasounds.playersoundid22 = Audio.SfxOpen(Misc.resolveSoundFile("bullet-bill.ogg"))
extrasounds.playersoundid23 = Audio.SfxOpen(Misc.resolveSoundFile("grab.ogg"))
extrasounds.playersoundid24 = Audio.SfxOpen(Misc.resolveSoundFile("spring.ogg"))
extrasounds.playersoundid25 = Audio.SfxOpen(Misc.resolveSoundFile("hammer.ogg"))
extrasounds.playersoundid26 = Audio.SfxOpen(Misc.resolveSoundFile("slide.ogg"))
extrasounds.playersoundid27 = Audio.SfxOpen(Misc.resolveSoundFile("newpath.ogg"))
extrasounds.playersoundid28 = Audio.SfxOpen(Misc.resolveSoundFile("level-select.ogg"))
extrasounds.playersoundid29 = Audio.SfxOpen(Misc.resolveSoundFile("do.ogg"))
extrasounds.playersoundid30 = Audio.SfxOpen(Misc.resolveSoundFile("pause.ogg"))
extrasounds.playersoundid31 = Audio.SfxOpen(Misc.resolveSoundFile("key.ogg"))
extrasounds.playersoundid32 = Audio.SfxOpen(Misc.resolveSoundFile("pswitch.ogg"))
extrasounds.playersoundid33 = Audio.SfxOpen(Misc.resolveSoundFile("tail.ogg"))
extrasounds.playersoundid34 = Audio.SfxOpen(Misc.resolveSoundFile("racoon.ogg"))
extrasounds.playersoundid35 = Audio.SfxOpen(Misc.resolveSoundFile("boot.ogg"))
extrasounds.playersoundid36 = Audio.SfxOpen(Misc.resolveSoundFile("smash.ogg"))
extrasounds.playersoundid37 = Audio.SfxOpen(Misc.resolveSoundFile("thwomp.ogg"))
extrasounds.playersoundid38 = Audio.SfxOpen(Misc.resolveSoundFile("birdo-spit.ogg"))
extrasounds.playersoundid39 = Audio.SfxOpen(Misc.resolveSoundFile("birdo-hit.ogg"))
extrasounds.playersoundid40 = Audio.SfxOpen(Misc.resolveSoundFile("smb2-exit.ogg"))
extrasounds.playersoundid41 = Audio.SfxOpen(Misc.resolveSoundFile("birdo-beat.ogg"))
extrasounds.playersoundid42 = Audio.SfxOpen(Misc.resolveSoundFile("npc-fireball.ogg"))
extrasounds.playersoundid43 = Audio.SfxOpen(Misc.resolveSoundFile("fireworks.ogg"))
extrasounds.playersoundid44 = Audio.SfxOpen(Misc.resolveSoundFile("bowser-killed.ogg"))
extrasounds.playersoundid45 = Audio.SfxOpen(Misc.resolveSoundFile("game-beat.ogg"))
extrasounds.playersoundid46 = Audio.SfxOpen(Misc.resolveSoundFile("door.ogg"))
extrasounds.playersoundid47 = Audio.SfxOpen(Misc.resolveSoundFile("message.ogg"))
extrasounds.playersoundid48 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi.ogg"))
extrasounds.playersoundid49 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-hurt.ogg"))
extrasounds.playersoundid50 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-tongue.ogg"))
extrasounds.playersoundid51 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-egg.ogg"))
extrasounds.playersoundid52 = Audio.SfxOpen(Misc.resolveSoundFile("got-star.ogg"))
extrasounds.playersoundid53 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-kill.ogg"))
extrasounds.playersoundid54 = Audio.SfxOpen(Misc.resolveSoundFile("player-died2.ogg"))
extrasounds.playersoundid55 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-swallow.ogg"))
extrasounds.playersoundid56 = Audio.SfxOpen(Misc.resolveSoundFile("ring.ogg"))
extrasounds.playersoundid57 = Audio.SfxOpen(Misc.resolveSoundFile("dry-bones.ogg"))
extrasounds.playersoundid58 = Audio.SfxOpen(Misc.resolveSoundFile("smw-checkpoint.ogg"))
extrasounds.playersoundid59 = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin.ogg"))
extrasounds.playersoundid60 = Audio.SfxOpen(Misc.resolveSoundFile("smw-exit.ogg"))
extrasounds.playersoundid61 = Audio.SfxOpen(Misc.resolveSoundFile("smw-blaarg.ogg"))
extrasounds.playersoundid62 = Audio.SfxOpen(Misc.resolveSoundFile("wart-bubble.ogg"))
extrasounds.playersoundid63 = Audio.SfxOpen(Misc.resolveSoundFile("wart-die.ogg"))
extrasounds.playersoundid64 = Audio.SfxOpen(Misc.resolveSoundFile("sm-block-hit.ogg"))
extrasounds.playersoundid65 = Audio.SfxOpen(Misc.resolveSoundFile("sm-killed.ogg"))
extrasounds.playersoundid66 = Audio.SfxOpen(Misc.resolveSoundFile("sm-hurt.ogg"))
extrasounds.playersoundid67 = Audio.SfxOpen(Misc.resolveSoundFile("sm-glass.ogg"))
extrasounds.playersoundid68 = Audio.SfxOpen(Misc.resolveSoundFile("sm-boss-hit.ogg"))
extrasounds.playersoundid69 = Audio.SfxOpen(Misc.resolveSoundFile("sm-cry.ogg"))
extrasounds.playersoundid70 = Audio.SfxOpen(Misc.resolveSoundFile("sm-explosion.ogg"))
extrasounds.playersoundid71 = Audio.SfxOpen(Misc.resolveSoundFile("climbing.ogg"))
extrasounds.playersoundid72 = Audio.SfxOpen(Misc.resolveSoundFile("swim.ogg"))
extrasounds.playersoundid73 = Audio.SfxOpen(Misc.resolveSoundFile("grab2.ogg"))
extrasounds.playersoundid74 = Audio.SfxOpen(Misc.resolveSoundFile("smw-saw.ogg"))
extrasounds.playersoundid75 = Audio.SfxOpen(Misc.resolveSoundFile("smb2-throw.ogg"))
extrasounds.playersoundid76 = Audio.SfxOpen(Misc.resolveSoundFile("smb2-hit.ogg"))
extrasounds.playersoundid77 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-stab.ogg"))
extrasounds.playersoundid78 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-hurt.ogg"))
extrasounds.playersoundid79 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-heart.ogg"))
extrasounds.playersoundid80 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-died.ogg"))
extrasounds.playersoundid81 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-rupee.ogg"))
extrasounds.playersoundid82 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fire.ogg"))
extrasounds.playersoundid83 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-item.ogg"))
extrasounds.playersoundid84 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-key.ogg"))
extrasounds.playersoundid85 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-shield.ogg"))
extrasounds.playersoundid86 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-dash.ogg"))
extrasounds.playersoundid87 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fairy.ogg"))
extrasounds.playersoundid88 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-grass.ogg"))
extrasounds.playersoundid89 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-hit.ogg"))
extrasounds.playersoundid90 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-sword-beam.ogg"))
extrasounds.playersoundid91 = Audio.SfxOpen(Misc.resolveSoundFile("bubble.ogg"))

--Additional SMBX Sounds
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

function extrasounds.onInitAPI() --This'll require a bunch of events to start
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
	
	ready = true --We're ready, so we can begin
end

function extrasounds.onTick() --This is a list of sounds that'll need to be replaced within each costume. They're muted here for obivious reasons.
	if extrasounds.active == true then --Only mute when active
		Audio.sounds[4].muted = true
		Audio.sounds[7].muted = true
		Audio.sounds[14].muted = true
		Audio.sounds[15].muted = true
		Audio.sounds[18].muted = true
		Audio.sounds[59].muted = true
	end
	if extrasounds.active == false then --Unmute when not active
		Audio.sounds[4].muted = false
		Audio.sounds[7].muted = false
		Audio.sounds[14].muted = false
		Audio.sounds[15].muted = false
		Audio.sounds[18].muted = false
		Audio.sounds[59].muted = false
	end
end

function extrasounds.onPostBlockHit(block, hitBlock, fromUpper, playerOrNil) --Let's start off with block hitting.
	local bricks = table.map{4,60,188,226} --These are a list of breakable bricks.
	if not Misc.isPaused() then --Making sure the sound only plays when not paused...
		if extrasounds.active == true then --If it's true, play them
			if block.contentID == nil then --For blocks that are already used
				SFX.play(extrasounds.playersoundid0)
			end
			if block.contentID == 1225 then --Add 1000 to get an actual content ID number. The first three are vine blocks.
				SFX.play(extrasounds.playersoundid92)
			elseif block.contentID == 1226 then
				SFX.play(extrasounds.playersoundid92)
			elseif block.contentID == 1227 then
				SFX.play(extrasounds.playersoundid92)
			elseif block.contentID == 0 then --This is to prevent a coin sound from playing when hitting an nonexistant block
				SFX.play(extrasounds.playersoundid0)
			elseif block.contentID == 1000 then --Same as last
				SFX.play(extrasounds.playersoundid0)
			elseif block.contentID >= 1001 then --Greater than blocks, exceptional to vine blocks, will play a mushroom spawn sound
				SFX.play(extrasounds.playersoundid7)
			elseif block.contentID <= 99 then --Elseif, we'll play a coin sound with things less than 99, the coin block limit
				SFX.play(extrasounds.playersoundid14)
			end
			if block:mem(0x10, FIELD_STRING) then --Detecting brick smashing
				if bricks[block.id] == (block.contentID >= 1) then --If it has a content ID, don't play a smash sound
					SFX.play(extrasounds.playersoundid0)
				elseif bricks[block.id] then --Or else play it
					SFX.play(extrasounds.playersoundid4)
				end
			end
		end
	end
end

function extrasounds.onInputUpdate() --Button pressing for such commands
	if not Misc.isPaused() then
		if extrasounds.active == true then
			if player.rawKeys.run == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false and player:mem(0x12E, FIELD_BOOL) == false then --Fireballs! It makes sure the player isn't on a mount, isn't ducking, or the fireball/iceball cooldown is less than 0 before playing
				if player.powerup == 3 then --Fireball sound
					SFX.play(extrasounds.playersoundid18)
				end
				if player.powerup == 7 then --Iceball sound
					SFX.play(extrasounds.playersoundid93)
				end
			end
		end
	end
end

function extrasounds.onPostNPCKill(npc, harmtype) --NPC Kill stuff, for custom coin sounds and etc.
	local starmans = table.map{994,996}
	local coins = table.map{10,33,88,103,138,258,528}
	local oneups = table.map{90,186,187}
	local threeups = table.map{188}
	if not Misc.isPaused() then
		if extrasounds.active == true then
			if coins[npc.id] then --Any coin ID that was marked above will play this sound when collected
				SFX.play(extrasounds.playersoundid14)
			end
			if npc.id == 558 then --Cherry sound effect
				SFX.play(extrasounds.playersoundid103)
			end
			if oneups[npc.id] then --1UP sound effect, so 3UPs can have a custom sound
				SFX.play(extrasounds.playersoundid15)
			end
			if npc.id == 188 then --3UP sound effect
				SFX.play(extrasounds.playersoundid97)
			end
			if npc.id == 274 then --Dragon coin counter sounds
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
					--Play 1UP sound as well when it says "1UP"
					SFX.play(extrasounds.playersoundid15)
					SFX.play(extrasounds.playersoundid102)
				end
			end
		end
	end
end

return extrasounds --This ends the library