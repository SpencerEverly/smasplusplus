local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

function onStart()
	Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	Misc.saveGame()
end

function onEvent()
	if eventName == "BootDialogueMusicReset" then
		Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	end
	if eventName == "ExitDialogueMusicReset" then
		Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	end
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onDraw()
	local bluecurtains = Graphics.loadImageResolved("theming_smbxcurtainsblue.png")
	Graphics.drawImage(bluecurtains, 0, 0, 2)
end