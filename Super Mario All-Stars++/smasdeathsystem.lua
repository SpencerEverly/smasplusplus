--smasdeathsystem, or anotherDeathSystem by Spencer Everly
--Check all the comments, plus the end of the file for more info

local Routine = require("routine")
local extrasounds = require("extrasounds")

local smasdeathsystem = {}

if SaveData.deathCount == nil then --Death count! For outside 1.3 mode, and inside it
	SaveData.deathCount = 0
end

local killed = false
local ready = false
local time = 0
local opacity = math.min(1,time/42)
local fadeoutcompleted = false

function smasdeathsystem.onInitAPI() --This requires all the libraries that will be used
	registerEvent(smasdeathsystem, "onDraw")
	registerEvent(smasdeathsystem, "onExit")
	registerEvent(smasdeathsystem, "onTick")
	registerEvent(smasdeathsystem, "onPlayerKill")
	
	ready = true
end

function diedanimation() --The entire animation when dying. The pause and sound is there to avoid not animating at all, but is IS a nice touch
	if (player.character == CHARACTER_MARIO) == true or (player.character == CHARACTER_LUIGI) == true or (player.character == CHARACTER_PEACH) == true or (player.character == CHARACTER_TOAD) == true or (player.character == CHARACTER_LINK) == true or (player.character == CHARACTER_MEGAMAN) == true or (player.character == CHARACTER_WARIO) == true or (player.character == CHARACTER_BOWSER) == true or (player.character == CHARACTER_KLONOA) == true or (player.character == CHARACTER_ROSALINA) == true or (player.character == CHARACTER_SNAKE) == true or (player.character == CHARACTER_ZELDA) == true or (player.character == CHARACTER_ULTIMATERINKA) == true or (player.character == CHARACTER_UNCLEBROADSWORD) == true or (player.character == CHARACTER_SAMUS) == true then
		if player.deathTimer == 0 then
			GameData.cutsceneMusicControl = true
			Audio.MusicVolume(0)
			SaveData.deathCount = SaveData.deathCount + 1 --This marks a death count, for info regarding how many times you died
			Misc.saveGame() --Save the game to save what we've added/edited
			Routine.waitFrames(165, true)
			Misc.pause()
			fadeoutdeath = true --This starts the fade out animation
			Routine.waitFrames(100, true)
			fadeoutcompleted = true --When waited enough time, unpause and detect the life count
			Misc.unpause()
			GameData.cutsceneMusicControl = false
			if fadeoutcompleted then --Or else, just exit the level
				smasdeathsystem.hasDied = true
				if smasdeathsystem.extramapexit == false then
					--Keep going until actually dead
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
			SaveData.deathCount = SaveData.deathCount + 1 --This marks a death count, for info regarding how many times you died
			Misc.saveGame() --Save the game to save what we've added/edited
			Routine.waitFrames(310, true)
			fadeoutcompleted = true --When waited enough time, unpause and detect the life count
			Misc.unpause()
			GameData.cutsceneMusicControl = false
			if fadeoutcompleted then --Or else, just exit the level
				smasdeathsystem.hasDied = true
				if smasdeathsystem.extramapexit == false then
					--Keep going until actually dead
				elseif smasdeathsystem.extramapexit == true then
					Level.load("SMAS - Map.lvlx", nil, nil)
				end
			end
		end
	end
end

function smasdeathsystem.onTick()
	if mem(0x00B2C5AC, FIELD_FLOAT, 1) and SaveData.disableX2char == false then
		mem(0x00B2C5AC, FIELD_FLOAT, 1)
	end
	if mem(0x00B2C5AC, FIELD_FLOAT, 1) and SaveData.disableX2char == true then
		--Don't keep to one, just keep going down when dying
	end
end

function smasdeathsystem.onDraw()
	if fadeoutdeath then --Fade out related code
		time = time + 1
		Graphics.drawScreen{color = Color.black..math.max(0,time/35),priority = 5}
	end
end

function smasdeathsystem.onPlayerKill()
	Routine.run(diedanimation) --This will run the animation. Without it, the player would just die
end

function smasdeathsystem.onExit()
	GameData.cutsceneMusicControl = false --This is specific for my episode. Remove this if you wanna use this yourself.
	Audio.MusicVolume(65) --Reset the music exiting the level
	if smasdeathsystem.hasDied == true and smasdeathsystem.extramapexit == false then
		--Exit level
	elseif smasdeathsystem.hasDied == true and smasdeathsystem.extramapexit == true then
		Level.load("SMAS - Map.lvlx", nil, nil)
	end
end

--SaveData.gameOverCount = 0 --This is only when the library publically releases for the wild to use
smasdeathsystem.hasDied = false --If the player died or not
smasdeathsystem.extramapexit = false --This'll only be true on extra DLC levels/extra games' level luna.lua's in future updates

return smasdeathsystem