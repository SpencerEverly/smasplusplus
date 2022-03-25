--smasdeathsystem, or anotherDeathCoinSystem by Spencer Everly
--Check all the comments, plus the end of the file for more info

local Routine = require("routine")
local extrasounds = require("extrasounds")

local smasdeathsystem = {}

if SaveData.newlives == nil then --This makes all the new SaveData datas for making the new lives and the system
	SaveData.newlives = 5
end
if SaveData.deathCount == nil then
	SaveData.deathCount = 0
end
if SaveData.coins == nil then
	SaveData.coins = 0
end

local killed = false
local oldlives = mem(0x00B2C5AC,FIELD_FLOAT) --Mem value for the old lives system
local ready = false
local time = 0
local opacity = math.min(1,time/42)
local fadeoutcompleted = false

function smasdeathsystem.onInitAPI() --This requires all the libraries that will be used
	registerEvent(smasdeathsystem, "onDraw")
	registerEvent(smasdeathsystem, "onExit")
	registerEvent(smasdeathsystem, "onTick")
	registerEvent(smasdeathsystem, "onTickEnd")
	registerEvent(smasdeathsystem, "onEvent")
	registerEvent(smasdeathsystem, "onInputUpdate")
	registerEvent(smasdeathsystem, "onNPCKill")
	registerEvent(smasdeathsystem, "onPostNPCKill")
	registerEvent(smasdeathsystem, "onPlayerKill")
	registerEvent(smasdeathsystem, "onPostPlayerKill")
	registerEvent(smasdeathsystem, "onStart")
	registerEvent(smasdeathsystem, "onPostBlockHit")
	
	if Player(2) and Player(2).isValid then return end --Don't run this when Player(2) is active... for now (Support coming soon)
	
	ready = true
end

function diedanimation() --The entire animation when dying. The pause and sound is there to avoid not animating at all, but is IS a nice touch
	if (player.character == CHARACTER_MARIO) == true or (player.character == CHARACTER_LUIGI) == true or (player.character == CHARACTER_PEACH) == true or (player.character == CHARACTER_TOAD) == true or (player.character == CHARACTER_LINK) == true or (player.character == CHARACTER_MEGAMAN) == true or (player.character == CHARACTER_WARIO) == true or (player.character == CHARACTER_BOWSER) == true or (player.character == CHARACTER_KLONOA) == true or (player.character == CHARACTER_ROSALINA) == true or (player.character == CHARACTER_SNAKE) == true or (player.character == CHARACTER_ZELDA) == true or (player.character == CHARACTER_ULTIMATERINKA) == true or (player.character == CHARACTER_UNCLEBROADSWORD) == true or (player.character == CHARACTER_SAMUS) == true then
		if player.deathTimer == 0 then
			GameData.cutsceneMusicControl = true
			Audio.MusicVolume(0)
			Misc.pause()
			--Routine.waitFrames(1, true)
			Misc.unpause()
			SaveData.newlives = SaveData.newlives - 1 --This subtracts when beginning to die. Hooray real time death tallies!
			SaveData.deathCount = SaveData.deathCount + 1 --This marks a death count, for info regarding how many times you died
			Misc.saveGame() --Save the game to save what we've added/edited
			Routine.waitFrames(165, true)
			Misc.pause()
			fadeoutdeath = true --This starts the fade out animation
			Routine.waitFrames(120, true)
			fadeoutcompleted = true --When waited enough time, unpause and detect the life count
			Misc.unpause()
			GameData.cutsceneMusicControl = false
			if fadeoutcompleted and SaveData.newlives <= 0 then --If 0, then do a game over, or whatever you want to put here
				Level.load("SMAS - Game Over.lvlx", nil, nil)
			elseif fadeoutcompleted then --Or else, just exit the level
				smasdeathsystem.hasDied = true
				if smasdeathsystem.extramapexit == false then
					Level.exit()
				elseif smasdeathsystem.extramapexit == true then
					Level.load("SMAS - Map.lvlx", nil, nil)
				end
			end
		end
	end
	if (player.character == CHARACTER_NINJABOMBERMAN) == true then --Do a different death animation with yiYoshi if active
		if player.deathTimer == 0 then
			GameData.cutsceneMusicControl = true
			Audio.MusicVolume(0)
			Misc.pause()
			--Routine.waitFrames(1, true)
			Misc.unpause()
			SaveData.newlives = SaveData.newlives - 1 --This subtracts when beginning to die. Hooray real time death tallies!
			SaveData.deathCount = SaveData.deathCount + 1 --This marks a death count, for info regarding how many times you died
			Misc.saveGame() --Save the game to save what we've added/edited
			Routine.waitFrames(310, true)
			fadeoutcompleted = true --When waited enough time, unpause and detect the life count
			Misc.unpause()
			GameData.cutsceneMusicControl = false
			if fadeoutcompleted and SaveData.newlives <= 0 then --If 0, then do a game over, or whatever you want to put here
				Level.load("SMAS - Game Over.lvlx", nil, nil)
			elseif fadeoutcompleted then --Or else, just exit the level
				smasdeathsystem.hasDied = true
				if smasdeathsystem.extramapexit == false then
					Level.exit()
				elseif smasdeathsystem.extramapexit == true then
					Level.load("SMAS - Map.lvlx", nil, nil)
				end
			end
		end
	end
end

function smasdeathsystem.onPostBlockHit(block, hitBlock, fromUpper, playerOrNil)
	local bricks = table.map{4,60,188,226} --These are a list of breakable bricks.
	if block.contentID == nil then --For blocks that are already used
		SFX.play(extrasounds.id0)
	end
	if block.contentID == 0 then --This is to prevent coins from being collected when hitting an nonexistant block
		SFX.play(extrasounds.id0)
	elseif block.contentID == 1000 then --Same as last
		SFX.play(extrasounds.id0)
	elseif block.contentID <= 99 then --We'll get a coin with things less than 99, the coin block limit
		SaveData.coins = SaveData.coins + 1
	end
end

function smasdeathsystem.onPostNPCKill(npc, harmtype, playerornil, obj) --This'll gain 1UPs when touching 1UPs, 3UPs, or etc.
	local oneups = table.map{90,186,187} --A table map containing all the NPC ids, same as below
	local threeups = table.map{188}
	local coins = table.map{10,33,88,103,138,258,528} --This'll add a coin system
	for key,npc in ipairs(NPC.get()) do
		if NPC.config[npc.id].score == 11 then --Score values, doesn't work just yet
			SaveData.newlives = SaveData.newlives + 1
		end
		if NPC.config[npc.id].score == 12 then
			SaveData.newlives = SaveData.newlives + 2
		end
		if NPC.config[npc.id].score == 13 then
			SaveData.newlives = SaveData.newlives + 3
		end
		if NPC.config[npc.id].score == 14 then
			SaveData.newlives = SaveData.newlives + 5
		end
	end
	for _,p in ipairs(Player.get()) do
		if oneups[npc.id] and HARM_TYPE_VANISH and Colliders.collide(p, npc) then --This'll gain the player a 1UP
			SaveData.newlives = SaveData.newlives + 1
		end
		if threeups[npc.id] and HARM_TYPE_VANISH and Colliders.collide(p, npc) then --This'll gain the player a 3UP
			SaveData.newlives = SaveData.newlives + 3
		end
		
		if coins[npc.id] and HARM_TYPE_VANISH and Colliders.collide(p, npc) then --This'll work in a coin collecting system
			SaveData.coins = SaveData.coins + 1
		end
	end
end

function smasdeathsystem.onDraw()
	if fadeoutdeath then --Fade out related code
		time = time + 1
		Graphics.drawScreen{color = Color.black..math.max(0,time/35),priority = 5}
	end
end

function smasdeathsystem.onTick()
	if SaveData.newlives > 999 then --999 will be the max lives for SMAS++
		SaveData.newlives = 999
	end
	if mem(0x00B2C5AC,FIELD_FLOAT,95) then
		mem(0x00B2C5AC,FIELD_FLOAT,85) --This is to make sure 1UPs get collected within this system, also useful for tracking 1UPs
	end
	mem(0x00B2C5A8, FIELD_WORD, 0) --Set the coin count to 0 as well, so that the new coin system will actually work
end

function smasdeathsystem.onTickEnd()
	if SaveData.coins <= 99 then --If less than 99, keep it as is
		SaveData.coins = SaveData.coins
	end
	if SaveData.coins >= 100 then --But if more than 100, set to 0 and give a player a life
		SaveData.coins = 0
		SaveData.newlives = SaveData.newlives + 1
		SFX.play(extrasounds.id15,1,1,40)
	end
end

function smasdeathsystem.onPlayerKill()
	Routine.run(diedanimation) --This will run the animation. Without it, the player would just die
end

function smasdeathsystem.onExit()
	GameData.cutsceneMusicControl = false --This is specific for my episode. Remove this if you wanna use this yourself.
	Audio.MusicVolume(65) --Reset the music exiting the level
	if smasdeathsystem.hasDied == true and smasdeathsystem.extramapexit == false then
		Level.exit()
	elseif SaveData.newlives <= 0 then
		Level.load("SMAS - Game Over.lvlx", nil, nil)
	end
	if smasdeathsystem.hasDied == true and smasdeathsystem.extramapexit == true then
		Level.load("SMAS - Map.lvlx", nil, nil)
	end
end

--SaveData.gameOverCount = 0 --This is only when the library publically releases for the wild to use
smasdeathsystem.hasDied = false --If the player died or not
smasdeathsystem.extramapexit = false --This'll only be true on extra DLC levels/extra games' level luna.lua's in future updates

return smasdeathsystem