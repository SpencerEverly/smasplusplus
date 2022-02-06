local level_dependencies_normal= require("level_dependencies_normal")

--Copy these, they'll be important for changing music throughout characters anywhere
local section0 = 0
local section1 = 1
local section2 = 2
local section3 = 3
local section4 = 4
local section5 = 5
local section6 = 6
local section7 = 7
local section8 = 8
local section9 = 9
local section10 = 10
local section11 = 11
local section12 = 12
local section13 = 13
local section14 = 14
local section15 = 15
local section16 = 16
local section17 = 17
local section18 = 18
local section19 = 19
local section20 = 20

Graphics.activateHud(false)

function onInitAPI()
	registerEvent("onExitLevel", "onExit");
	registerEvent("onKeyboardPress");
end

function onStart()
	Audio.MusicVolume(nil)
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
	if eventName == "LoadWSMBA" then
		Misc.saveGame()
		Misc.loadEpisode("Where SMB Attacks (SMAS++)")
		if Misc.loadEpisode("Where SMB Attacks (SMAS++)") == false then
			Misc.saveGame()
			SFX.play("wrong.wav")
			player:teleport(-199632, -200176)
			triggerEvent("WSMBANotFound")
		end
	end
end

function onExit()
	Audio.MusicVolume(nil)
end