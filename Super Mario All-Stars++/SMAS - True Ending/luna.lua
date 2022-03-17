local level_dependencies_normal= require("level_dependencies_normal")
local Routine = require("routine")
local inventory = require("furyinventory")

local stars = mem(0x00B251E0, FIELD_WORD)

local whiteflash = false
local blackscreen = false
local invisible = false

local timer1 = 0
local speed = 0
local numberup = 0
local time = 0

local opacity = timer1/speed
local middle = math.floor(timer1*numberup)

local function Crash()
	Misc.saveGame()
	Routine.wait(0.1, true)
	--mem(0x00B257F0, FIELD_FLOAT, 245353464654)
	Misc.exitEngine()
end

local function WhiteFadeInSlow()
	whiteflashpre1 = true
end

function onLoad()
	if SaveData.disableX2char == 1 then
		SaveData.disableX2char = SaveData.disableX2char - 1
	end
end

function onStart()
	Audio.MusicVolume(nil)
end

function onTick()
	Audio.sounds[52].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
	Audio.sounds[45].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
	if invisible == true then
		player:setFrame(50)
	end
end

function onEvent(eventName)
	if eventName == "GenosideEnding" then
		Audio.MusicChange(0, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(1, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(2, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(3, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(4, "_OST/Undertale/mus_inmyway.ogg")
		Audio.MusicChange(5, "_OST/Undertale/mus_smallshock_genoside.ogg")
		Audio.MusicChange(6, "_OST/Undertale/mus_inmyway.ogg")
		Audio.MusicChange(7, "_OST/Undertale/mus_inmyway.ogg")
	end
	if eventName == "Ending Complete" then
		Level.endState(LEVEL_END_STATE_GAMEEND, true)
		SFX.play("_OST/All Stars Secrets/True Ending Completed (SFX).ogg")
	end
	if eventName == "NormalCutsceneBegin" then
		pausemenu.pauseactivated = false
		inventory.cutsceneActive = true
		player:teleport(-78784, -80128)
		triggerEvent("NormalCutsceneBegin2")
		player.keys.left = false
		player.keys.right = false
		player.keys.pause = false
		player.keys.dropItem = false
		player.keys.altRun = false
		player.keys.up = false
		player.keys.down = false
		player.keys.altJump = false
		Audio.MusicChange(6, 0)
		Graphics.activateHud(false)
		inventory.activateinventory = false
		SFX.play("_OST/_Sound Effects/mus_explosion.ogg")
		whiteflash = true
		player.setCostume(1, nil)
		player:transform(1, false)
		Audio.sounds[1].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
		Audio.sounds[2].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
		Audio.sounds[3].sfx  = Audio.SfxOpen("_OST/_Sound Effects/nothing.ogg")
	end
	if eventName == "NormalCutscene1" then
		whiteflash = false
		invisible = true
		SFX.play(5)
	end
	if eventName == "NormalCutscene2" then
		Audio.MusicChange(6, "_OST/Deltarune/GALLERY.ogg")
	end
	if eventName == "NormalCutscene3" then
		SFX.play("_OST/_Sound Effects/raca-chant.ogg")
	end
	if eventName == "NormalCutscene4" then
		
	end
	if eventName == "NormalCutscene5" then
		Audio.MusicChange(6, 0)
	end
	if eventName == "NormalCutscene6" then
		if SaveData.racaActivated == nil then
			SaveData.racaActivated = SaveData.racaActivated or 0
		end
		SaveData.racaActivated = 1
		SaveData.introselect = 1
		Misc.saveGame()
		Routine.run(WhiteFadeInSlow)
		SFX.play("_OST/_Sound Effects/raca-chant.ogg")
		SFX.play("_OST/Undertale/mus_cymbal.ogg")
		Misc.saveGame()
	end
	if eventName == "CrashExecute" then
		Misc.saveGame()
		Routine.run(Crash)
	end
end

function onDraw()
	if whiteflash then
		Graphics.drawScreen{color = Color.white, priority = 10}
	end
	if blackscreen then
		Graphics.drawScreen{color = Color.black, priority = 10}
	end
	if whiteflashpre1 then
		time = time + 1
		Graphics.drawScreen{color = Color.white..math.max(0,time/293),priority = 10}
	end
end

function onEnd()
	if Level.finish(LEVEL_END_STATE_GAMEEND) then
		Level.load("SMAS - Credits.lvlx", nil, nil)
	end
end