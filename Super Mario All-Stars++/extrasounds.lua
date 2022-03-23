--extrasounds.lua by Spencer Everly
--
--To have costume compability, require this library with playermanager on any/all costumes you're using, then replace sound slot IDs 4,7,14,15,18,43,59 from (example):
--
--Audio.sounds[14].sfx = Audio.SfxOpen("costumes/(character)/(costume)/coin.ogg")
--to
--extrasounds.id14 = Audio.SfxOpen(Misc.resolveSoundFile("costumes/(character)/(costume)/coin.ogg"))
--
--Check the lua file for info on which things does what

local extrasounds = {}

local spinballcounter = 1

extrasounds.active = true --Are the extra sounds active? If not, they won't play. If false the library won't be used and will revert to the stock sound system. Useful for muting all sounds for a boot menu, cutscene, or something like that by using Audio.sounds[id].muted = true instead.

local ready = false --This library isn't ready until onInit is finished

extrasounds.id = {}

extrasounds.id0 = Audio.SfxOpen(Misc.resolveSoundFile("sound/nothing.ogg")) --General sound to mute anything, really

--Stock SMBX Sounds
extrasounds.id1 = Audio.SfxOpen(Misc.resolveSoundFile("player-jump.ogg"))
extrasounds.id2 = Audio.SfxOpen(Misc.resolveSoundFile("stomped.ogg"))
extrasounds.id3 = Audio.SfxOpen(Misc.resolveSoundFile("block-hit.ogg"))
extrasounds.id4 = Audio.SfxOpen(Misc.resolveSoundFile("block-smash.ogg"))
extrasounds.id5 = Audio.SfxOpen(Misc.resolveSoundFile("player-shrink.ogg"))
extrasounds.id6 = Audio.SfxOpen(Misc.resolveSoundFile("player-grow.ogg"))
extrasounds.id7 = Audio.SfxOpen(Misc.resolveSoundFile("mushroom.ogg"))
extrasounds.id8 = Audio.SfxOpen(Misc.resolveSoundFile("player-died.ogg"))
extrasounds.id9 = Audio.SfxOpen(Misc.resolveSoundFile("shell-hit.ogg"))
extrasounds.id10 = Audio.SfxOpen(Misc.resolveSoundFile("player-slide.ogg"))
extrasounds.id11 = Audio.SfxOpen(Misc.resolveSoundFile("item-dropped.ogg"))
extrasounds.id12 = Audio.SfxOpen(Misc.resolveSoundFile("has-item.ogg"))
extrasounds.id13 = Audio.SfxOpen(Misc.resolveSoundFile("camera-change.ogg"))
extrasounds.id14 = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
extrasounds.id15 = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
extrasounds.id16 = Audio.SfxOpen(Misc.resolveSoundFile("lava.ogg"))
extrasounds.id17 = Audio.SfxOpen(Misc.resolveSoundFile("warp.ogg"))
extrasounds.id18 = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
extrasounds.id19 = Audio.SfxOpen(Misc.resolveSoundFile("level-win.ogg"))
extrasounds.id20 = Audio.SfxOpen(Misc.resolveSoundFile("boss-beat.ogg"))
extrasounds.id21 = Audio.SfxOpen(Misc.resolveSoundFile("dungeon-win.ogg"))
extrasounds.id22 = Audio.SfxOpen(Misc.resolveSoundFile("bullet-bill.ogg"))
extrasounds.id23 = Audio.SfxOpen(Misc.resolveSoundFile("grab.ogg"))
extrasounds.id24 = Audio.SfxOpen(Misc.resolveSoundFile("spring.ogg"))
extrasounds.id25 = Audio.SfxOpen(Misc.resolveSoundFile("hammer.ogg"))
extrasounds.id26 = Audio.SfxOpen(Misc.resolveSoundFile("slide.ogg"))
extrasounds.id27 = Audio.SfxOpen(Misc.resolveSoundFile("newpath.ogg"))
extrasounds.id28 = Audio.SfxOpen(Misc.resolveSoundFile("level-select.ogg"))
extrasounds.id29 = Audio.SfxOpen(Misc.resolveSoundFile("do.ogg"))
extrasounds.id30 = Audio.SfxOpen(Misc.resolveSoundFile("pause.ogg"))
extrasounds.id31 = Audio.SfxOpen(Misc.resolveSoundFile("key.ogg"))
extrasounds.id32 = Audio.SfxOpen(Misc.resolveSoundFile("pswitch.ogg"))
extrasounds.id33 = Audio.SfxOpen(Misc.resolveSoundFile("tail.ogg"))
extrasounds.id34 = Audio.SfxOpen(Misc.resolveSoundFile("racoon.ogg"))
extrasounds.id35 = Audio.SfxOpen(Misc.resolveSoundFile("boot.ogg"))
extrasounds.id36 = Audio.SfxOpen(Misc.resolveSoundFile("smash.ogg"))
extrasounds.id37 = Audio.SfxOpen(Misc.resolveSoundFile("thwomp.ogg"))
extrasounds.id38 = Audio.SfxOpen(Misc.resolveSoundFile("birdo-spit.ogg"))
extrasounds.id39 = Audio.SfxOpen(Misc.resolveSoundFile("birdo-hit.ogg"))
extrasounds.id40 = Audio.SfxOpen(Misc.resolveSoundFile("smb2-exit.ogg"))
extrasounds.id41 = Audio.SfxOpen(Misc.resolveSoundFile("birdo-beat.ogg"))
extrasounds.id42 = Audio.SfxOpen(Misc.resolveSoundFile("npc-fireball.ogg"))
extrasounds.id43 = Audio.SfxOpen(Misc.resolveSoundFile("fireworks.ogg"))
extrasounds.id44 = Audio.SfxOpen(Misc.resolveSoundFile("bowser-killed.ogg"))
extrasounds.id45 = Audio.SfxOpen(Misc.resolveSoundFile("game-beat.ogg"))
extrasounds.id46 = Audio.SfxOpen(Misc.resolveSoundFile("door.ogg"))
extrasounds.id47 = Audio.SfxOpen(Misc.resolveSoundFile("message.ogg"))
extrasounds.id48 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi.ogg"))
extrasounds.id49 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-hurt.ogg"))
extrasounds.id50 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-tongue.ogg"))
extrasounds.id51 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-egg.ogg"))
extrasounds.id52 = Audio.SfxOpen(Misc.resolveSoundFile("got-star.ogg"))
extrasounds.id53 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-kill.ogg"))
extrasounds.id54 = Audio.SfxOpen(Misc.resolveSoundFile("player-died2.ogg"))
extrasounds.id55 = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-swallow.ogg"))
extrasounds.id56 = Audio.SfxOpen(Misc.resolveSoundFile("ring.ogg"))
extrasounds.id57 = Audio.SfxOpen(Misc.resolveSoundFile("dry-bones.ogg"))
extrasounds.id58 = Audio.SfxOpen(Misc.resolveSoundFile("smw-checkpoint.ogg"))
extrasounds.id59 = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin.ogg"))
extrasounds.id60 = Audio.SfxOpen(Misc.resolveSoundFile("smw-exit.ogg"))
extrasounds.id61 = Audio.SfxOpen(Misc.resolveSoundFile("smw-blaarg.ogg"))
extrasounds.id62 = Audio.SfxOpen(Misc.resolveSoundFile("wart-bubble.ogg"))
extrasounds.id63 = Audio.SfxOpen(Misc.resolveSoundFile("wart-die.ogg"))
extrasounds.id64 = Audio.SfxOpen(Misc.resolveSoundFile("sm-block-hit.ogg"))
extrasounds.id65 = Audio.SfxOpen(Misc.resolveSoundFile("sm-killed.ogg"))
extrasounds.id66 = Audio.SfxOpen(Misc.resolveSoundFile("sm-hurt.ogg"))
extrasounds.id67 = Audio.SfxOpen(Misc.resolveSoundFile("sm-glass.ogg"))
extrasounds.id68 = Audio.SfxOpen(Misc.resolveSoundFile("sm-boss-hit.ogg"))
extrasounds.id69 = Audio.SfxOpen(Misc.resolveSoundFile("sm-cry.ogg"))
extrasounds.id70 = Audio.SfxOpen(Misc.resolveSoundFile("sm-explosion.ogg"))
extrasounds.id71 = Audio.SfxOpen(Misc.resolveSoundFile("climbing.ogg"))
extrasounds.id72 = Audio.SfxOpen(Misc.resolveSoundFile("swim.ogg"))
extrasounds.id73 = Audio.SfxOpen(Misc.resolveSoundFile("grab2.ogg"))
extrasounds.id74 = Audio.SfxOpen(Misc.resolveSoundFile("smw-saw.ogg"))
extrasounds.id75 = Audio.SfxOpen(Misc.resolveSoundFile("smb2-throw.ogg"))
extrasounds.id76 = Audio.SfxOpen(Misc.resolveSoundFile("smb2-hit.ogg"))
extrasounds.id77 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-stab.ogg"))
extrasounds.id78 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-hurt.ogg"))
extrasounds.id79 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-heart.ogg"))
extrasounds.id80 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-died.ogg"))
extrasounds.id81 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-rupee.ogg"))
extrasounds.id82 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fire.ogg"))
extrasounds.id83 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-item.ogg"))
extrasounds.id84 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-key.ogg"))
extrasounds.id85 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-shield.ogg"))
extrasounds.id86 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-dash.ogg"))
extrasounds.id87 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fairy.ogg"))
extrasounds.id88 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-grass.ogg"))
extrasounds.id89 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-hit.ogg"))
extrasounds.id90 = Audio.SfxOpen(Misc.resolveSoundFile("zelda-sword-beam.ogg"))
extrasounds.id91 = Audio.SfxOpen(Misc.resolveSoundFile("bubble.ogg"))

--Additional SMBX Sounds
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
extrasounds.id104 = Audio.SfxOpen(Misc.resolveSoundFile("sound/explode.ogg"))
extrasounds.id105 = Audio.SfxOpen(Misc.resolveSoundFile("sound/hammerthrow.ogg"))

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
		Audio.sounds[43].muted = true
		Audio.sounds[59].muted = true
		if (player:mem(0x55, FIELD_WORD) == 255) or (player:mem(0x55, FIELD_WORD) == 0) then --This is code related to spinjump fireball/iceball shooting. It's not on the docs, I found this memory address myself
			if player:mem(0x50, FIELD_BOOL) == true then --Is the player spinjumping?
				spinballcounter = spinballcounter - 1
				if player.powerup == 3 then --Fireball sound
					SFX.play(extrasounds.id18, 1, 1, 30)
				end
				if player.powerup == 7 then --Iceball sound
					SFX.play(extrasounds.id93, 1, 1, 30)
				end
				if spinballcounter <= 0 then --If it's zero, stop playing
					if extrasounds.id18.playing then
						extrasounds.id18:stop()
					elseif extrasounds.id93.playing then
						extrasounds.id93:stop()
					end
				end
			end
		end
		--if Misc.givePoints(10,vector(player.x, player.y)) == true then
		--	SFX.play(extrasounds.id15)
		--end
		--if Misc.givePoints(11,vector(player.x, player.y)) == true then
		--	SFX.play(extrasounds.id96)
		--end
		--if Misc.givePoints(12,vector(player.x, player.y)) == true then
		--	SFX.play(extrasounds.id97)
		--end
		--if Misc.givePoints(13,vector(player.x, player.y)) == true then
		--	SFX.play(extrasounds.id98)
		--end
	end
	if extrasounds.active == false then --Unmute when not active
		Audio.sounds[4].muted = false
		Audio.sounds[7].muted = false
		Audio.sounds[14].muted = false
		Audio.sounds[15].muted = false
		Audio.sounds[18].muted = false
		Audio.sounds[43].muted = false
		Audio.sounds[59].muted = false
	end
end

function extrasounds.onDraw()
	--Text.print(NPC:mem(0x24, FIELD_WORD), 100, 100)
end

function extrasounds.onPostBlockHit(block, hitBlock, fromUpper, playerOrNil) --Let's start off with block hitting.
	local bricks = table.map{4,60,188,226} --These are a list of breakable bricks.
	if not Misc.isPaused() then --Making sure the sound only plays when not paused...
		if extrasounds.active == true then --If it's true, play them
			if block.contentID == nil then --For blocks that are already used
				SFX.play(extrasounds.id0)
			end
			if block.contentID == 1225 then --Add 1000 to get an actual content ID number. The first three are vine blocks.
				SFX.play(extrasounds.id92)
			elseif block.contentID == 1226 then
				SFX.play(extrasounds.id92)
			elseif block.contentID == 1227 then
				SFX.play(extrasounds.id92)
			elseif block.contentID == 0 then --This is to prevent a coin sound from playing when hitting an nonexistant block
				SFX.play(extrasounds.id0)
			elseif block.contentID == 1000 then --Same as last
				SFX.play(extrasounds.id0)
			elseif block.contentID >= 1001 then --Greater than blocks, exceptional to vine blocks, will play a mushroom spawn sound
				SFX.play(extrasounds.id7)
			elseif block.contentID <= 99 then --Elseif, we'll play a coin sound with things less than 99, the coin block limit
				SFX.play(extrasounds.id14)
			end
			if player.powerup >= 2 then --Smash bricks only when you are big and up
				if block:mem(0x10, FIELD_STRING) then --Detecting brick smashing
					if bricks[block.id] == (block.contentID >= 1) then --If it has a content ID, don't play a smash sound
						SFX.play(extrasounds.id0)
					elseif bricks[block.id] then --Or else play it
						SFX.play(extrasounds.id4)
					end
				end
			elseif player.powerup == 1 then
				if block:mem(0x10, FIELD_STRING) then --Detecting brick smashing
					if bricks[block.id] == (block.contentID >= 1) then --If it has a content ID, don't play a smash sound
						SFX.play(extrasounds.id0)
					elseif bricks[block.id] then --Also don't when you are small
						SFX.play(extrasounds.id0)
					end
				end
			end
		end
	end
end

function extrasounds.onPostExplosion(effect)
	if effect.id == 69 then
		SFX.play(extrasounds.id104)
	end
	if effect.id == 76 then
		SFX.play(extrasounds.id43)
	end
end

function extrasounds.onInputUpdate() --Button pressing for such commands
	if not Misc.isPaused() then
		if extrasounds.active == true then
			if player.rawKeys.run == KEYS_PRESSED or player.rawKeys.altRun == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false and player:mem(0x12E, FIELD_BOOL) == false and player:mem(0x3C, FIELD_BOOL) == false  and (player.forcedState == FORCEDSTATE_PIPE) == false and (player.forcedState == FORCEDSTATE_DOOR) == false then --Fireballs! It makes sure the player isn't on a mount, isn't ducking, isn't sliding, isn't warping, isn't going through a door, or the fireball/iceball cooldown is less than 0 before playing
				if player.powerup == 3 then --Fireball sound
					SFX.play(extrasounds.id18)
				end
				if player.powerup == 6 then --Fireball sound
					SFX.play(extrasounds.id105)
				end
				if player.powerup == 7 then --Iceball sound
					SFX.play(extrasounds.id93)
				end
			end
		end
	end
end

function extrasounds.onPostNPCKill(npc, harmtype, playerornil) --NPC Kill stuff, for custom coin sounds and etc.
	local starmans = table.map{994,996}
	local coins = table.map{10,33,88,103,138,258,528}
	local oneups = table.map{90,186,187}
	local threeups = table.map{188}
	if not Misc.isPaused() then
		if extrasounds.active == true then
			if coins[npc.id] and HARM_TYPE_VANISH then --Any coin ID that was marked above will play this sound when collected
				SFX.play(extrasounds.id14)
			end
			if npc.id == 558 and HARM_TYPE_VANISH then --Cherry sound effect
				SFX.play(extrasounds.id103)
			end
			if oneups[npc.id] and HARM_TYPE_VANISH then --1UP sound effect, so 3UPs can have a custom sound
				SFX.play(extrasounds.id15)
			end
			if npc.id == 188 and HARM_TYPE_VANISH then --3UP sound effect
				SFX.play(extrasounds.id97)
			end
			if npc.id == 274  and HARM_TYPE_VANISH then --Dragon coin counter sounds
				if NPC.config[npc.id].score == 6 then
					SFX.play(extrasounds.id59)
				elseif NPC.config[npc.id].score == 7 then
					SFX.play(extrasounds.id59)
				elseif NPC.config[npc.id].score == 8 then
					SFX.play(extrasounds.id99)
				elseif NPC.config[npc.id].score == 9 then
					SFX.play(extrasounds.id100)
				elseif NPC.config[npc.id].score == 10 then
					SFX.play(extrasounds.id101)
				elseif NPC.config[npc.id].score >= 11 then
					--Play 1UP sound as well when it says "1UP"
					SFX.play(extrasounds.id15)
					SFX.play(extrasounds.id102)
				end
			end
		end
	end
end

return extrasounds --This ends the library