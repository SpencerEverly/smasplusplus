local Routine = require("routine")
local extrasounds = require("extrasounds")

local smasdeathsystem = {}

if SaveData.newlives == nil then
	SaveData.newlives = 5
end
if SaveData.deathCount == nil then
	SaveData.deathCount = 0
end

local killed = false
local oldlives = mem(0x00B2C5AC,FIELD_FLOAT)
local ready = false
local time = 0
local opacity = math.min(1,time/42)
local fadeoutcompleted = false

function smasdeathsystem.onInitAPI()
	registerEvent(smasdeathsystem, "onDraw")
	registerEvent(smasdeathsystem, "onExit")
	registerEvent(smasdeathsystem, "onTick")
	registerEvent(smasdeathsystem, "onEvent")
	registerEvent(smasdeathsystem, "onInputUpdate")
	registerEvent(smasdeathsystem, "onPostNPCKill")
	registerEvent(smasdeathsystem, "onPlayerKill")
	registerEvent(smasdeathsystem, "onPostPlayerKill")
	registerEvent(smasdeathsystem, "onStart")
	
	if Player(2) and Player(2).isValid then return end
	
	ready = true
end

function diedanimation()
	if player.deathTimer == 0 then
		GameData.starActive = true
		Audio.MusicVolume(0)
		SFX.play("_OST/_Sound Effects/playerpostdead.ogg")
		Misc.pause()
		Routine.waitFrames(55, true)
		Misc.unpause()
		SaveData.newlives = SaveData.newlives - 1
		SaveData.deathCount = SaveData.deathCount + 1
		Misc.saveGame()
		oldlives = oldlives - 1 --Let's make sure to not use the official life system with this
		Routine.waitFrames(165, true)
		Misc.pause()
		fadeoutdeath = true
		Routine.waitFrames(120, true)
		fadeoutcompleted = true
		Misc.unpause()
		if fadeoutcompleted and SaveData.newlives <= 0 then
			Level.load("SMAS - Game Over.lvlx", nil, nil)
		elseif fadeoutcompleted then
			smasdeathsystem.hasDied = true
			Level.exit()
		end
	end
end

function smasdeathsystem.onPostNPCKill(npc, harmtype, playerornil)
	local oneups = table.map{90,186,187}
	local threeups = table.map{188}
	if NPC.config[npc.id].score == 10 then
		SFX.play(extrasounds.id15)
		SaveData.newlives = SaveData.newlives + 1
	end
	if NPC.config[npc.id].score == 11 then
		SFX.play(extrasounds.id96)
		SaveData.newlives = SaveData.newlives + 2
	end
	if NPC.config[npc.id].score == 12 then
		SFX.play(extrasounds.id97)
		SaveData.newlives = SaveData.newlives + 3
	end
	if NPC.config[npc.id].score == 13 then
		SFX.play(extrasounds.id98)
		SaveData.newlives = SaveData.newlives + 5
	end
end

function smasdeathsystem.onDraw()
	if fadeoutdeath then
		time = time + 1
		Graphics.drawScreen{color = Color.black..math.max(0,time/35),priority = 5}
	end
end

function smasdeathsystem.onTick()

end

function smasdeathsystem.onPlayerKill()
	Routine.run(diedanimation)
end

function smasdeathsystem.onExit()
	GameData.starActive = false
	Audio.MusicVolume(64)
	if smasdeathsystem.hasDied == true then
		Level.exit()
	elseif SaveData.newlives <= 0 then
		Level.load("SMAS - Game Over.lvlx", nil, nil)
	end
end

SaveData.newlives = 5
SaveData.deathCount = 0
--SaveData.smasdeathsystem.gameOverCount = 0 --This is only when the library publically releases for the wild to use
smasdeathsystem.hasDied = false --If the player died or not

return smasdeathsystem