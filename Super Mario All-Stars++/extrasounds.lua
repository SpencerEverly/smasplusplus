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
local combo = 0
local time = 0

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
extrasounds.id92 = Audio.SfxOpen(Misc.resolveSoundFile("sound/sprout-vine.ogg")) --Vine sprout
extrasounds.id93 = Audio.SfxOpen(Misc.resolveSoundFile("sound/iceball.ogg")) --Iceball
extrasounds.id94 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_freeze.ogg")) --Freeze enemies
extrasounds.id95 = Audio.SfxOpen(Misc.resolveSoundFile("sound/yi_icebreak.ogg")) --Enemy ice breaker
extrasounds.id96 = Audio.SfxOpen(Misc.resolveSoundFile("sound/2up.ogg")) --2UP
extrasounds.id97 = Audio.SfxOpen(Misc.resolveSoundFile("sound/3up.ogg")) --3UP
extrasounds.id98 = Audio.SfxOpen(Misc.resolveSoundFile("sound/5up.ogg")) --5UP
extrasounds.id99 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get2.ogg")) --Dragon Coin #2
extrasounds.id100 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get3.ogg")) --Dragon Coin #3
extrasounds.id101 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get4.ogg")) --Dragon Coin #4
extrasounds.id102 = Audio.SfxOpen(Misc.resolveSoundFile("sound/dragon-coin-get5.ogg")) --Dragon Coin #5
extrasounds.id103 = Audio.SfxOpen(Misc.resolveSoundFile("sound/cherry.ogg")) --Cherry
extrasounds.id104 = Audio.SfxOpen(Misc.resolveSoundFile("sound/explode.ogg")) --SMB2 Explosion
extrasounds.id105 = Audio.SfxOpen(Misc.resolveSoundFile("sound/hammerthrow.ogg")) --Player hammer throw
extrasounds.id106 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo1.ogg")) --Shell hit 2
extrasounds.id107 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo2.ogg")) --Shell hit 3
extrasounds.id108 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo3.ogg")) --Shell hit 4
extrasounds.id109 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo4.ogg")) --Shell hit 5
extrasounds.id110 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo5.ogg")) --Shell hit 6
extrasounds.id111 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo6.ogg")) --Shell hit 7
extrasounds.id112 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo7.ogg")) --Shell hit 8
extrasounds.id113 = Audio.SfxOpen(Misc.resolveSoundFile("sound/combo8.ogg")) --Shell hit 9, basically a shell hit and a 1UP together

function extrasounds.onInitAPI() --This'll require a bunch of events to start
	registerEvent(extrasounds, "onKeyboardPress")
	registerEvent(extrasounds, "onDraw")
	registerEvent(extrasounds, "onLevelExit")
	registerEvent(extrasounds, "onTick")
	registerEvent(extrasounds, "onTickEnd")
	registerEvent(extrasounds, "onInputUpdate")
	registerEvent(extrasounds, "onStart")
	registerEvent(extrasounds, "onPostNPCKill")
	registerEvent(extrasounds, "onNPCKill")
	registerEvent(extrasounds, "onPostNPCHarm")
	registerEvent(extrasounds, "onNPCHarm")
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
		if not isOverworld then
			for index,scoreboard in ipairs(Animation.get(79)) do --Score values!
				if scoreboard.animationFrame == 9 then --1UP
					SFX.play(extrasounds.id15, 1, 1, 70)
				end
				if scoreboard.animationFrame == 10 then --2UP
					SFX.play(extrasounds.id96, 1, 1, 70)
				end
				if scoreboard.animationFrame == 11 then --3UP
					SFX.play(extrasounds.id97, 1, 1, 70)
				end
				if scoreboard.animationFrame == 12 then --5UP
					SFX.play(extrasounds.id98, 1, 1, 70)
				end
			end
		end
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

function extrasounds.onPostBlockHit(block, hitBlock, fromUpper, playerornil) --Let's start off with block hitting.
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
			elseif block.contentID <= 99 and (player.character == CHARACTER_LINK) == false then --Elseif, we'll play a coin sound with things less than 99, the coin block limit
				SFX.play(extrasounds.id14)
			end
			if (player.character == CHARACTER_LINK) == false and (player.character == CHARACTER_MEGAMAN) == false and (player.character == CHARACTER_SNAKE) == false and (player.character == CHARACTER_SAMUS) == false then --Making sure these sounds don't play when using these characters...
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
end

function extrasounds.onPostExplosion(effect)
	if extrasounds.active == true then
		if effect.id == 69 then
			SFX.play(extrasounds.id104)
		end
		if effect.id == 71 then
			SFX.play(extrasounds.id43)
		end
	end
end

function extrasounds.onInputUpdate() --Button pressing for such commands
	if not Misc.isPaused() then
		if extrasounds.active == true then
			if (player.character == CHARACTER_LINK) == false and (player.character == CHARACTER_MEGAMAN) == false and (player.character == CHARACTER_SNAKE) == false and (player.character == CHARACTER_SAMUS) == false then --Making sure these sounds don't play when using these characters...
				if player.rawKeys.run == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false and player:mem(0x12E, FIELD_BOOL) == false and player:mem(0x3C, FIELD_BOOL) == false  and (player.forcedState == FORCEDSTATE_PIPE) == false and (player.forcedState == FORCEDSTATE_DOOR) == false then --Fireballs! It makes sure the player isn't on a mount, isn't ducking, isn't sliding, isn't warping, isn't going through a door, or the fireball/iceball cooldown is less than or equal to 0 before playing
					if player.powerup == 3 then --Fireball sound
						SFX.play(extrasounds.id18)
					end
					if player.powerup == 6 then --Hammer Throw sound
						SFX.play(extrasounds.id105)
					end
					if player.powerup == 7 then --Iceball sound
						SFX.play(extrasounds.id93)
					end
				end
				if player.rawKeys.altRun == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false and player:mem(0x12E, FIELD_BOOL) == false and player:mem(0x3C, FIELD_BOOL) == false  and (player.forcedState == FORCEDSTATE_PIPE) == false and (player.forcedState == FORCEDSTATE_DOOR) == false and not player:getCostume() == ("SEE-TANGENT") then --Fireballs! It makes sure the player isn't on a mount, isn't ducking, isn't sliding, isn't warping, isn't going through a door, or the fireball/iceball cooldown is less than or equal to 0 before playing
					if player.powerup == 3 then --Fireball sound
						SFX.play(extrasounds.id18)
					end
					if player.powerup == 6 then --Hammer Throw sound
						SFX.play(extrasounds.id105)
					end
					if player.powerup == 7 then --Iceball sound
						SFX.play(extrasounds.id93)
					end
				end
				if mem(0x00A3C87F, FIELD_BYTE, 14) then --This plays a coin sound when NpcToCoin happens
					SFX.play(extrasounds.id14)
				end
			end
		end
	end
end

function extrasounds.onPostNPCKill(npc, harmtype, player, v) --NPC Kill stuff, for custom coin sounds and etc.
	local starmans = table.map{994,996}
	local coins = table.map{10,33,88,103,138,258,411,528}
	local oneups = table.map{90,186,187}
	local threeups = table.map{188}
	local allenemies = table.map{1,2,3,4,5,6,7,8,12,15,17,18,19,20,23,24,25,27,28,29,36,37,38,39,42,43,44,47,48,51,52,53,54,55,59,61,63,65,71,72,73,74,76,77,89,93,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,135,137,161,162,163,164,165,166,167,168,172,173,174,175,176,177,180,189,199,200,201,203,204,205,206,207,209,210,229,230,231,232,233,234,235,236,242,243,244,245,247,261,262,267,268,270,271,272,275,280,281,284,285,286,294,295,296,298,299,301,302,303,304,305,307,309,311,312,313,314,315,316,317,318,321,323,324,333,345,346,347,350,351,352,357,360,365,368,369,371,372,373,374,375,377,379,380,382,383,386,388,389,392,393,395,401,406,407,408,409,413,415,431,437,446,447,448,449,459,460,461,463,464,466,467,469,470,471,472,485,486,487,490,491,492,493,509,510,512,513,514,515,516,517,418,519,520,521,522,523,524,529,530,539,562,563,564,572,578,579,580,586,587,588,589,590,610,611,612,613,614,616,618,619,624,666} --Every single X2 enemy.
	if not Misc.isPaused() then
		if extrasounds.active == true then
			for _,p in ipairs(Player.get()) do --This will get actions regards to the player itself
				if coins[npc.id] and Colliders.collide(p, npc) then --Any coin ID that was marked above will play this sound when collected
					SFX.play(extrasounds.id14)
				end
				if npc.id == 558 and Colliders.collide(p, npc) then --Cherry sound effect
					SFX.play(extrasounds.id103)
				end
				if npc.id == 274 and Colliders.collide(p, npc) then --Dragon coin counter sounds
					if NPC.config[npc.id].score == 7 then
						SFX.play(extrasounds.id59)
					elseif NPC.config[npc.id].score == 8 then
						SFX.play(extrasounds.id99)
					elseif NPC.config[npc.id].score == 9 then
						SFX.play(extrasounds.id100)
					elseif NPC.config[npc.id].score == 10 then
						SFX.play(extrasounds.id101)
					elseif NPC.config[npc.id].score == 11 then
						SFX.play(extrasounds.id102)
					end
				end
			end
		end
	end
end

return extrasounds --This ends the library