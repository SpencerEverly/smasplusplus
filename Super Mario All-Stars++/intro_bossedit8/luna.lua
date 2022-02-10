local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

function onStart()
	Audio.MusicChange(0, "_OST/Super Smash Bros. Melee/smari3.ogg")
	Misc.saveGame()
end

function onEvent()
	if eventName == "BootDialogueMusicReset" then
		Audio.MusicChange(0, "_OST/Super Smash Bros. Melee/smari3.ogg")
	end
	if eventName == "ExitDialogueMusicReset" then
		Audio.MusicChange(0, "_OST/Super Smash Bros. Melee/smari3.ogg")
	end
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end