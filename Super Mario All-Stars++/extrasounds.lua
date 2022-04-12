--extrasounds.lua by Spencer Everly
--
--To have costume compability, require this library with playermanager on any/all costumes you're using, then replace sound slot IDs 4,7,8,14,15,18,43,59 from (example):
--
--Audio.sounds[14].sfx = Audio.SfxOpen("costumes/(character)/(costume)/coin.ogg")
--to
--extrasounds.id[14] = Audio.SfxOpen(Misc.resolveSoundFile("costumes/(character)/(costume)/coin.ogg"))
--
--Check the lua file for info on which things does what

local extrasounds = {}

local spinballcounter = 1
local combo = 0
local time = 0

extrasounds.active = true --Are the extra sounds active? If not, they won't play. If false the library won't be used and will revert to the stock sound system. Useful for muting all sounds for a boot menu, cutscene, or something like that by using Audio.sounds[id].muted = true instead.

local ready = false --This library isn't ready until onInit is finished

extrasounds.id = {}
extrasounds.id[0] = Audio.SfxOpen(Misc.resolveSoundFile("sound/nothing.ogg")) --General sound to mute anything, really
--All SMBX sounds (To play the stock sounds regardless of it being muted), including additional ones
for k,v in ipairs({
	"player-jump",
	"stomped",
	"block-hit",
	"block-smash",
	"player-shrink",
	"player-grow",
	"mushroom",
	"player-died",
	"shell-hit",
	"player-slide",
	"item-dropped",
	"has-item",
	"camera-change",
	"coin",
	"1up",
	"lava",
	"warp",
	"fireball",
	"level-win",
	"boss-beat",
	"dungeon-win",
	"bullet-bill",
	"grab",
	"spring",
	"hammer",
	"slide",
	"newpath",
	"level-select",
	"do",
	"pause",
	"key",
	"pswitch",
	"tail",
	"racoon",
	"boot",
	"smash",
	"thwomp",
	"birdo-spit",
	"birdo-hit",
	"smb2-exit",
	"birdo-beat",
	"npc-fireball",
	"fireworks",
	"bowser-killed",
	"game-beat",
	"door",
	"message",
	"yoshi",
	"yoshi-hurt",
	"yoshi-tongue",
	"yoshi-egg",
	"got-star",
	"zelda-kill",
	"player-died2",
	"yoshi-swallow",
	"ring",
	"dry-bones",
	"smw-checkpoint",
	"dragon-coin",
	"smw-exit",
	"smw-blaarg",
	"wart-bubble",
	"wart-die",
	"sm-block-hit",
	"sm-killed",
	"sm-glass",
	"sm-hurt",
	"sm-boss-hit",
	"sm-cry",
	"sm-explosion",
	"climbing",
	"swim",
	"grab2",
	"smw-saw",
	"smb2-throw",
	"smb2-hit",
	"zelda-stab",
	"zelda-hurt",
	"zelda-heart",
	"zelda-died",
	"zelda-rupee",
	"zelda-fire",
	"zelda-item",
	"zelda-key",
	"zelda-shield",
	"zelda-dash",
	"zelda-fairy",
	"zelda-grass",
	"zelda-hit",
	"zelda-sword-beam",
	"bubble",
	"sprout-vine",
	"iceball",
	"yi_freeze",
	"yi_icebreak",
	"2up",
	"3up",
	"5up",
	"dragon-coin-get2",
	"dragon-coin-get3",
	"dragon-coin-get4",
	"dragon-coin-get5",
	"cherry",
	"explode",
	"hammerthrow",
	"combo1",
	"combo2",
	"combo3",
	"combo4",
	"combo5",
	"combo6",
	"combo7",
}) do
	extrasounds.id[k] = Audio.SfxOpen(Misc.resolveSoundFile(v))
end

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
	registerEvent(extrasounds, "onPlayerKill")
	
	local Routine = require("routine")
	
	ready = true --We're ready, so we can begin
end

function extrasounds.onTick() --This is a list of sounds that'll need to be replaced within each costume. They're muted here for obivious reasons.
	if extrasounds.active == true then --Only mute when active
		Audio.sounds[4].muted = true --block-smash.ogg
		Audio.sounds[7].muted = true --mushroom.ogg
		Audio.sounds[8].muted = true --player-dead.ogg
		Audio.sounds[14].muted = true --coin.ogg
		Audio.sounds[15].muted = true --1up.ogg
		Audio.sounds[18].muted = true --fireball.ogg
		Audio.sounds[43].muted = true --fireworks.ogg
		Audio.sounds[59].muted = true --dragon-coin.ogg
		if (player:mem(0x55, FIELD_WORD) == 255) or (player:mem(0x55, FIELD_WORD) == 0) then --This is code related to spinjump fireball/iceball shooting. It's not on the docs, I found this memory address myself
			if player:mem(0x50, FIELD_BOOL) == true then --Is the player spinjumping?
				spinballcounter = spinballcounter - 1
				if player.powerup == 3 then --Fireball sound
					SFX.play(extrasounds.id[18], 1, 1, 30)
				end
				if player.powerup == 7 then --Iceball sound
					SFX.play(extrasounds.id[93], 1, 1, 30)
				end
				if spinballcounter <= 0 then --If it's zero, stop playing
					if extrasounds.id[18].playing then
						extrasounds.id[18]:stop()
					elseif extrasounds.id[93].playing then
						extrasounds.id[93]:stop()
					end
				end
			end
		end
		if not isOverworld then
			for index,scoreboard in ipairs(Animation.get(79)) do --Score values!
				if scoreboard.animationFrame == 9 then --1UP
					SFX.play(extrasounds.id[15], 1, 1, 70)
				end
				if scoreboard.animationFrame == 10 then --2UP
					SFX.play(extrasounds.id[96], 1, 1, 70)
				end
				if scoreboard.animationFrame == 11 then --3UP
					SFX.play(extrasounds.id[97], 1, 1, 70)
				end
				if scoreboard.animationFrame == 12 then --5UP
					SFX.play(extrasounds.id[98], 1, 1, 70)
				end
			end
		end
	end
	if extrasounds.active == false then --Unmute when not active
		Audio.sounds[4].muted = false --block-smash.ogg
		Audio.sounds[7].muted = false --mushroom.ogg
		Audio.sounds[8].muted = false --player-dead.ogg
		Audio.sounds[14].muted = false --coin.ogg
		Audio.sounds[15].muted = false --1up.ogg
		Audio.sounds[18].muted = false --fireball.ogg
		Audio.sounds[43].muted = false --fireworks.ogg
		Audio.sounds[59].muted = false --dragon-coin.ogg
	end
end

function extrasounds.onPostBlockHit(block, hitBlock, fromUpper, playerornil) --Let's start off with block hitting.
	local bricks = table.map{4,60,188,226} --These are a list of breakable bricks.
	if not Misc.isPaused() then --Making sure the sound only plays when not paused...
		if extrasounds.active == true then --If it's true, play them
			if block.contentID == nil then --For blocks that are already used
				playSound(0)
			end
			if block.contentID == 1225 then --Add 1000 to get an actual content ID number. The first three are vine blocks.
				playSound(92)
			elseif block.contentID == 1226 then
				playSound(92)
			elseif block.contentID == 1227 then
				playSound(92)
			elseif block.contentID == 0 then --This is to prevent a coin sound from playing when hitting an nonexistant block
				playSound(0)
			elseif block.contentID == 1000 then --Same as last
				playSound(0)
			elseif block.contentID >= 1001 then --Greater than blocks, exceptional to vine blocks, will play a mushroom spawn sound
				SFX.play(extrasounds.id[7])
			elseif block.contentID <= 99 and (player.character == CHARACTER_LINK) == false then --Elseif, we'll play a coin sound with things less than 99, the coin block limit
				playSound(14)
			end
			if (player.character == CHARACTER_LINK) == false and (player.character == CHARACTER_MEGAMAN) == false and (player.character == CHARACTER_SNAKE) == false and (player.character == CHARACTER_SAMUS) == false then --Making sure these sounds don't play when using these characters...
				if player.powerup >= 2 then --Smash bricks only when you are big and up
					if block:mem(0x10, FIELD_STRING) then --Detecting brick smashing
						if bricks[block.id] == (block.contentID >= 1) then --If it has a content ID, don't play a smash sound
							playSound(0)
						elseif bricks[block.id] then --Or else play it
							playSound(4)
						end
					end
				elseif player.powerup == 1 then
					if block:mem(0x10, FIELD_STRING) then --Detecting brick smashing
						if bricks[block.id] == (block.contentID >= 1) then --If it has a content ID, don't play a smash sound
							playSound(0)
						elseif bricks[block.id] then --Also don't when you are small
							playSound(0)
						end
					end
				end
			end
		end
	end
end

function extrasounds.onPlayerKill()
	playSound(8)
end

function extrasounds.onPostExplosion(effect)
	if extrasounds.active == true then
		if effect.id == 69 then
			playSound(104)
		end
		if effect.id == 71 then
			playSound(43)
		end
	end
end

function extrasounds.onInputUpdate() --Button pressing for such commands
	if not Misc.isPaused() then
		if extrasounds.active == true then
			if (player.character == CHARACTER_LINK) == false and (player.character == CHARACTER_MEGAMAN) == false and (player.character == CHARACTER_SNAKE) == false and (player.character == CHARACTER_SAMUS) == false then --Making sure these sounds don't play when using these characters...
				if player.rawKeys.run == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false and player:mem(0x12E, FIELD_BOOL) == false and player:mem(0x3C, FIELD_BOOL) == false  and (player.forcedState == FORCEDSTATE_PIPE) == false and (player.forcedState == FORCEDSTATE_DOOR) == false then --Fireballs! It makes sure the player isn't on a mount, isn't ducking, isn't sliding, isn't warping, isn't going through a door, or the fireball/iceball cooldown is less than or equal to 0 before playing
					if player.powerup == 3 then --Fireball sound
						playSound(18)
					end
					if player.powerup == 6 then --Hammer Throw sound
						playSound(105)
					end
					if player.powerup == 7 then --Iceball sound
						playSound(93)
					end
				end
				if player.rawKeys.altRun == KEYS_PRESSED and player:mem(0x160, FIELD_WORD) <= 0 and (player.mount == MOUNT_YOSHI) == false and player.climbing == false and player:mem(0x12E, FIELD_BOOL) == false and player:mem(0x3C, FIELD_BOOL) == false  and (player.forcedState == FORCEDSTATE_PIPE) == false and (player.forcedState == FORCEDSTATE_DOOR) == false and not player:getCostume() == ("SEE-TANGENT") then --Fireballs! It makes sure the player isn't on a mount, isn't ducking, isn't sliding, isn't warping, isn't going through a door, or the fireball/iceball cooldown is less than or equal to 0 before playing
					if player.powerup == 3 then --Fireball sound
						playSound(18)
					end
					if player.powerup == 6 then --Hammer Throw sound
						playSound(105)
					end
					if player.powerup == 7 then --Iceball sound
						playSound(93)
					end
				end
				if mem(0x00A3C87F, FIELD_BYTE, 14) then --This plays a coin sound when NpcToCoin happens
					playSound(14)
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
					playSound(14)
				end
				if npc.id == 558 and Colliders.collide(p, npc) then --Cherry sound effect
					playSound(103)
				end
				if npc.id == 274 and Colliders.collide(p, npc) then --Dragon coin counter sounds
					if NPC.config[npc.id].score == 7 then
						playSound(59)
					elseif NPC.config[npc.id].score == 8 then
						playSound(99)
					elseif NPC.config[npc.id].score == 9 then
						playSound(100)
					elseif NPC.config[npc.id].score == 10 then
						playSound(101)
					elseif NPC.config[npc.id].score == 11 then
						playSound(102)
					end
				end
			end
		end
	end
end

return extrasounds --This ends the library