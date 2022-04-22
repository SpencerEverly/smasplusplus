--extrasounds.lua by Spencer Everly
--
--To have costume compability, require this library with playermanager on any/all costumes you're using, then replace sound slot IDs 4,7,8,14,15,18,39,42,43,59 from (example):
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
extrasounds.id[0]   = Audio.SfxOpen(Misc.resolveSoundFile("nothing.ogg")) --General sound to mute anything, really

--Stock SMBX Sounds
extrasounds.id[1]   = Audio.SfxOpen(Misc.resolveSoundFile("player-jump.ogg"))
extrasounds.id[2]   = Audio.SfxOpen(Misc.resolveSoundFile("stomped.ogg"))
extrasounds.id[3]   = Audio.SfxOpen(Misc.resolveSoundFile("block-hit.ogg"))
extrasounds.id[4]   = Audio.SfxOpen(Misc.resolveSoundFile("block-smash.ogg"))
extrasounds.id[5]   = Audio.SfxOpen(Misc.resolveSoundFile("player-shrink.ogg"))
extrasounds.id[6]   = Audio.SfxOpen(Misc.resolveSoundFile("player-grow.ogg"))
extrasounds.id[7]   = Audio.SfxOpen(Misc.resolveSoundFile("mushroom.ogg"))
extrasounds.id[8]   = Audio.SfxOpen(Misc.resolveSoundFile("player-died.ogg"))
extrasounds.id[9]   = Audio.SfxOpen(Misc.resolveSoundFile("shell-hit.ogg"))
extrasounds.id[10]  = Audio.SfxOpen(Misc.resolveSoundFile("player-slide.ogg"))
extrasounds.id[11]  = Audio.SfxOpen(Misc.resolveSoundFile("item-dropped.ogg"))
extrasounds.id[12]  = Audio.SfxOpen(Misc.resolveSoundFile("has-item.ogg"))
extrasounds.id[13]  = Audio.SfxOpen(Misc.resolveSoundFile("camera-change.ogg"))
extrasounds.id[14]  = Audio.SfxOpen(Misc.resolveSoundFile("coin.ogg"))
extrasounds.id[15]  = Audio.SfxOpen(Misc.resolveSoundFile("1up.ogg"))
extrasounds.id[16]  = Audio.SfxOpen(Misc.resolveSoundFile("lava.ogg"))
extrasounds.id[17]  = Audio.SfxOpen(Misc.resolveSoundFile("warp.ogg"))
extrasounds.id[18]  = Audio.SfxOpen(Misc.resolveSoundFile("fireball.ogg"))
extrasounds.id[19]  = Audio.SfxOpen(Misc.resolveSoundFile("level-win.ogg"))
extrasounds.id[20]  = Audio.SfxOpen(Misc.resolveSoundFile("boss-beat.ogg"))
extrasounds.id[21]  = Audio.SfxOpen(Misc.resolveSoundFile("dungeon-win.ogg"))
extrasounds.id[22]  = Audio.SfxOpen(Misc.resolveSoundFile("bullet-bill.ogg"))
extrasounds.id[23]  = Audio.SfxOpen(Misc.resolveSoundFile("grab.ogg"))
extrasounds.id[24]  = Audio.SfxOpen(Misc.resolveSoundFile("spring.ogg"))
extrasounds.id[25]  = Audio.SfxOpen(Misc.resolveSoundFile("hammer.ogg"))
extrasounds.id[26]  = Audio.SfxOpen(Misc.resolveSoundFile("slide.ogg"))
extrasounds.id[27]  = Audio.SfxOpen(Misc.resolveSoundFile("newpath.ogg"))
extrasounds.id[28]  = Audio.SfxOpen(Misc.resolveSoundFile("level-select.ogg"))
extrasounds.id[29]  = Audio.SfxOpen(Misc.resolveSoundFile("do.ogg"))
extrasounds.id[30]  = Audio.SfxOpen(Misc.resolveSoundFile("pause.ogg"))
extrasounds.id[31]  = Audio.SfxOpen(Misc.resolveSoundFile("key.ogg"))
extrasounds.id[32]  = Audio.SfxOpen(Misc.resolveSoundFile("pswitch.ogg"))
extrasounds.id[33]  = Audio.SfxOpen(Misc.resolveSoundFile("tail.ogg"))
extrasounds.id[34]  = Audio.SfxOpen(Misc.resolveSoundFile("racoon.ogg"))
extrasounds.id[35]  = Audio.SfxOpen(Misc.resolveSoundFile("boot.ogg"))
extrasounds.id[36]  = Audio.SfxOpen(Misc.resolveSoundFile("smash.ogg"))
extrasounds.id[37]  = Audio.SfxOpen(Misc.resolveSoundFile("thwomp.ogg"))
extrasounds.id[38]  = Audio.SfxOpen(Misc.resolveSoundFile("birdo-spit.ogg"))
extrasounds.id[39]  = Audio.SfxOpen(Misc.resolveSoundFile("birdo-hit.ogg"))
extrasounds.id[40]  = Audio.SfxOpen(Misc.resolveSoundFile("smb2-exit.ogg"))
extrasounds.id[41]  = Audio.SfxOpen(Misc.resolveSoundFile("birdo-beat.ogg"))
extrasounds.id[42]  = Audio.SfxOpen(Misc.resolveSoundFile("npc-fireball.ogg"))
extrasounds.id[43]  = Audio.SfxOpen(Misc.resolveSoundFile("fireworks.ogg"))
extrasounds.id[44]  = Audio.SfxOpen(Misc.resolveSoundFile("bowser-killed.ogg"))
extrasounds.id[45]  = Audio.SfxOpen(Misc.resolveSoundFile("game-beat.ogg"))
extrasounds.id[46]  = Audio.SfxOpen(Misc.resolveSoundFile("door.ogg"))
extrasounds.id[47]  = Audio.SfxOpen(Misc.resolveSoundFile("message.ogg"))
extrasounds.id[48]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi.ogg"))
extrasounds.id[49]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-hurt.ogg"))
extrasounds.id[50]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-tongue.ogg"))
extrasounds.id[51]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-egg.ogg"))
extrasounds.id[52]  = Audio.SfxOpen(Misc.resolveSoundFile("got-star.ogg"))
extrasounds.id[53]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-kill.ogg"))
extrasounds.id[54]  = Audio.SfxOpen(Misc.resolveSoundFile("player-died2.ogg"))
extrasounds.id[55]  = Audio.SfxOpen(Misc.resolveSoundFile("yoshi-swallow.ogg"))
extrasounds.id[56]  = Audio.SfxOpen(Misc.resolveSoundFile("ring.ogg"))
extrasounds.id[57]  = Audio.SfxOpen(Misc.resolveSoundFile("dry-bones.ogg"))
extrasounds.id[58]  = Audio.SfxOpen(Misc.resolveSoundFile("smw-checkpoint.ogg"))
extrasounds.id[59]  = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin.ogg"))
extrasounds.id[60]  = Audio.SfxOpen(Misc.resolveSoundFile("smw-exit.ogg"))
extrasounds.id[61]  = Audio.SfxOpen(Misc.resolveSoundFile("smw-blaarg.ogg"))
extrasounds.id[62]  = Audio.SfxOpen(Misc.resolveSoundFile("wart-bubble.ogg"))
extrasounds.id[63]  = Audio.SfxOpen(Misc.resolveSoundFile("wart-die.ogg"))
extrasounds.id[64]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-block-hit.ogg"))
extrasounds.id[65]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-killed.ogg"))
extrasounds.id[66]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-hurt.ogg"))
extrasounds.id[67]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-glass.ogg"))
extrasounds.id[68]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-boss-hit.ogg"))
extrasounds.id[69]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-cry.ogg"))
extrasounds.id[70]  = Audio.SfxOpen(Misc.resolveSoundFile("sm-explosion.ogg"))
extrasounds.id[71]  = Audio.SfxOpen(Misc.resolveSoundFile("climbing.ogg"))
extrasounds.id[72]  = Audio.SfxOpen(Misc.resolveSoundFile("swim.ogg"))
extrasounds.id[73]  = Audio.SfxOpen(Misc.resolveSoundFile("grab2.ogg"))
extrasounds.id[74]  = Audio.SfxOpen(Misc.resolveSoundFile("smw-saw.ogg"))
extrasounds.id[75]  = Audio.SfxOpen(Misc.resolveSoundFile("smb2-throw.ogg"))
extrasounds.id[76]  = Audio.SfxOpen(Misc.resolveSoundFile("smb2-hit.ogg"))
extrasounds.id[77]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-stab.ogg"))
extrasounds.id[78]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-hurt.ogg"))
extrasounds.id[79]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-heart.ogg"))
extrasounds.id[80]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-died.ogg"))
extrasounds.id[81]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-rupee.ogg"))
extrasounds.id[82]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fire.ogg"))
extrasounds.id[83]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-item.ogg"))
extrasounds.id[84]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-key.ogg"))
extrasounds.id[85]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-shield.ogg"))
extrasounds.id[86]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-dash.ogg"))
extrasounds.id[87]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-fairy.ogg"))
extrasounds.id[88]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-grass.ogg"))
extrasounds.id[89]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-hit.ogg"))
extrasounds.id[90]  = Audio.SfxOpen(Misc.resolveSoundFile("zelda-sword-beam.ogg"))
extrasounds.id[91]  = Audio.SfxOpen(Misc.resolveSoundFile("bubble.ogg"))

--Additional SMBX Sounds
extrasounds.id[92]  = Audio.SfxOpen(Misc.resolveSoundFile("sprout-vine.ogg")) --Vine Sprout
extrasounds.id[93]  = Audio.SfxOpen(Misc.resolveSoundFile("iceball.ogg")) --Iceball
extrasounds.id[96]  = Audio.SfxOpen(Misc.resolveSoundFile("2up.ogg")) --2UP
extrasounds.id[97]  = Audio.SfxOpen(Misc.resolveSoundFile("3up.ogg")) --3UP
extrasounds.id[98]  = Audio.SfxOpen(Misc.resolveSoundFile("5up.ogg")) --5UP
extrasounds.id[99]  = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin-get2.ogg")) --Dragon Coin #2
extrasounds.id[100] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin-get3.ogg")) --Dragon Coin #3
extrasounds.id[101] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin-get4.ogg")) --Dragon Coin #4
extrasounds.id[102] = Audio.SfxOpen(Misc.resolveSoundFile("dragon-coin-get5.ogg")) --Dragon Coin #5
extrasounds.id[103] = Audio.SfxOpen(Misc.resolveSoundFile("cherry.ogg")) --Cherry
extrasounds.id[104] = Audio.SfxOpen(Misc.resolveSoundFile("explode.ogg")) --SMB2 Explosion
extrasounds.id[105] = Audio.SfxOpen(Misc.resolveSoundFile("hammerthrow.ogg")) --Player Hammer Throw
extrasounds.id[106] = Audio.SfxOpen(Misc.resolveSoundFile("combo1.ogg")) --Shell Hit 2
extrasounds.id[107] = Audio.SfxOpen(Misc.resolveSoundFile("combo2.ogg")) --Shell Hit 3
extrasounds.id[108] = Audio.SfxOpen(Misc.resolveSoundFile("combo3.ogg")) --Shell Hit 4
extrasounds.id[109] = Audio.SfxOpen(Misc.resolveSoundFile("combo4.ogg")) --Shell Hit 5
extrasounds.id[110] = Audio.SfxOpen(Misc.resolveSoundFile("combo5.ogg")) --Shell Hit 6
extrasounds.id[111] = Audio.SfxOpen(Misc.resolveSoundFile("combo6.ogg")) --Shell Hit 7
extrasounds.id[112] = Audio.SfxOpen(Misc.resolveSoundFile("combo7.ogg")) --Shell Hit 8
extrasounds.id[113] = Audio.SfxOpen(Misc.resolveSoundFile("score-tally.ogg")) --SMB1 Flagpole Score Tally
extrasounds.id[114] = Audio.SfxOpen(Misc.resolveSoundFile("score-tally-end.ogg")) --SMB1 Flagpole Score Tally (End)
extrasounds.id[115] = Audio.SfxOpen(Misc.resolveSoundFile("bowser-fire.ogg")) --Bowser Fireball

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
	registerEvent(extrasounds, "onExplosion")
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
		Audio.sounds[39].muted = true --birdo-hit.ogg
		Audio.sounds[42].muted = true --npc-fireball.ogg
		Audio.sounds[43].muted = true --fireworks.ogg
		Audio.sounds[59].muted = true --dragon-coin.ogg
		
		
		
		--**SPINJUMPING**
		if player:mem(0x50, FIELD_BOOL) == true then --Is the player spinjumping?
			if player:mem(0x160, FIELD_WORD) == 29 then --Is the fireball cooldown set to the highest number?
				if player.powerup == 3 then --Fireball sound
					playSound(18)
				end
				if player.powerup == 7 then --Iceball sound
					playSound(93)
				end
			end
		end
		
		
		
		
		
		--**NPCS**
		--*SMB3 Bowser*
		for k,v in ipairs(NPC.get(86)) do --Make sure the seperate Bowser fire sound plays when SMB3 Bowser actually fires up a fireball
			if v.ai4 == 4 then
				if v.ai3 == 25 then
					playSound(115)
				end
			end
		end
		--*SMB1 Bowser*
		for k,v in ipairs(NPC.get(200)) do --Make sure the seperate Bowser fire sound plays when SMB1 Bowser actually fires up a fireball
			if v.ai3 == 40 then
				playSound(115)
			end
		end
		--*SMW Ludwig Koopa*
		for k,v in ipairs(NPC.get(280)) do --Make sure the actual fire sound plays when Ludwig Koopa actually fires up a fireball
			if v.ai1 == 2 then
				SFX.play(extrasounds.id[42], 1, 1, 35)
			end
		end
		--*SMB3 Boom Boom*
		for k,v in ipairs(NPC.get(15)) do --Adding a hurt sound for Boom Boom cause why not lol
			if v.ai1 == 4 then
				SFX.play(extrasounds.id[39], 1, 1, 100)
			end
		end
		--*SMB2 Birdo*
		for k,v in ipairs(NPC.get(15)) do --Birdo has some sounds that'll need to be reimplemented
			if v.ai1 == -30 then
				SFX.play(extrasounds.id[39], 1, 1, 30)
			end
		end
		
		
		
		
		--**SCOREBOARD**
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
			for index,explosion in ipairs(Animation.get(69)) do --Explosions!
				SFX.play(extrasounds.id[104], 1, 1, 70)
			end
			for index,explosion in ipairs(Animation.get(71)) do
				SFX.play(extrasounds.id[43], 1, 1, 70)
			end
		end
		
		
		
		
		
		
		--**NPCTOCOIN**
		if mem(0x00A3C87F, FIELD_BYTE) == 14 and Level.endState() > 0 then --This plays a coin sound when NpcToCoin happens
			SFX.play(extrasounds.id[14], 1, 1, 2500)
		end
		
		
		
		
		
		
	end
	if extrasounds.active == false then --Unmute when not active
		Audio.sounds[4].muted = false --block-smash.ogg
		Audio.sounds[7].muted = false --mushroom.ogg
		Audio.sounds[8].muted = false --player-dead.ogg
		Audio.sounds[14].muted = false --coin.ogg
		Audio.sounds[15].muted = false --1up.ogg
		Audio.sounds[18].muted = false --fireball.ogg
		Audio.sounds[39].muted = false --birdo-hit.ogg
		Audio.sounds[42].muted = false --npc-fireball.ogg
		Audio.sounds[43].muted = false --fireworks.ogg
		Audio.sounds[59].muted = false --dragon-coin.ogg
	end
end

function extrasounds.onPostBlockHit(block, hitBlock, fromUpper, playerornil) --Let's start off with block hitting.
	local bricks = table.map{4,60,90,188,226,293,526} --These are a list of breakable bricks
	if extrasounds.active == true then --If it's true, play them
		if not Misc.isPaused() then --Making sure the sound only plays when not paused...
			
			
			
			
			
			--**CONTENT ID DETECTION**
			if block.contentID == nil then --For blocks that are already used
				
			end
			if block.contentID == 1225 then --Add 1000 to get an actual content ID number. The first three are vine blocks.
				playSound(92)
			elseif block.contentID == 1226 then
				playSound(92)
			elseif block.contentID == 1227 then
				playSound(92)
			elseif block.contentID == 0 then --This is to prevent a coin sound from playing when hitting an nonexistant block
				
			elseif block.contentID == 1000 then --Same as last
				
			elseif block.contentID >= 1001 then --Greater than blocks, exceptional to vine blocks, will play a mushroom spawn sound
				playSound(7)
			elseif block.contentID <= 99 then --Elseif, we'll play a coin sound with things less than 99, the coin block limit
				playSound(14)
			end
			
			
			
			
			--**BOWSER BRICKS**
			if block.id == 186 then --SMB3 Bowser Brick detection, thanks to looking at the source code
				playSound(43)
			end
			
			
			
			
			
			--**BRICK SMASHING**
			if player.powerup >= 2 then --No brick smashing when on powerup state 1
				if block:collidesWith(player) then --Detecting block hitting
					if bricks[block.id] == (block.contentID >= 1) then --If it has a content ID, don't play a smash sound
						playSound(0)
					end
					if bricks[block.id] == (block.contentID == 0) or bricks[block.id] == (block.contentID == 1000) then --Play when it's destroyed
						playSound(4)
					end
				end
			end
		end
	end
end

function extrasounds.onPostPlayerKill()
	if extrasounds.active == true then
	
	
	
	
		--**PLAYER DYING**
		if player.character == CHARACTER_LINK then
			SFX.play(80)
		else
			playSound(8)
		end
		
		
		
		
	end
end

function extrasounds.onInputUpdate() --Button pressing for such commands
	if not Misc.isPaused() then
		if extrasounds.active == true then
			
			
			
			
			
			
			--**FIREBALLS**
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
				
				
				
				
				
				--**COIN COLLECTING**
				if coins[npc.id] and Colliders.collide(p, npc) then --Any coin ID that was marked above will play this sound when collected
					playSound(14)
				end
				
				
				
				
				--**CHERRY COLLECTING**
				if npc.id == 558 and Colliders.collide(p, npc) then --Cherry sound effect
					playSound(103)
				end
				
				
				
				
				--**DRAGON COINS**
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