local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

local anotherPowerDownLibrary = require("anotherPowerDownLibrary")
local playerphysicspatch = require("playerphysicspatch")

Graphics.activateHud(false)

function onInitAPI()
	registerEvent("onExitLevel", "onExit");
	registerEvent("onKeyboardPress");
end

function onStart()
	Audio.MusicVolume(nil)
	Misc.saveGame()
end

function onTick()
	--Prevent donthurtme cheat, for obvious reasons
	Defines.cheat_donthurtme = used_donthurtme;
	used_donthurtme = nil;
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onEvent(eventName)
	if eventName == "LoadSMAS" then
		Misc.loadEpisode("Super Mario All-Stars++")
		if Misc.loadEpisode("Super Mario All-Stars++") == false then
			SFX.play("wrong.wav")
			player:teleport(-199632, -200176)
			triggerEvent("SMASNotFound")
		end
	end
	if eventName == "2PlayerCheck" then
		if player.count() == 1 then
			Cheats.trigger("2player")
			Defines.player_hasCheated = false
		end
	end
	if eventName == "2PlayerCheck2" then
		if player.count() == 2 then
			Cheats.trigger("1player")
			Defines.player_hasCheated = false
		end
	end
end

function onExit()
	Audio.MusicVolume(nil)
end