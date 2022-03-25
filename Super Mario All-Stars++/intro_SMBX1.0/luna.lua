local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

function onStart()
	Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onEvent()
	if eventName == "BootDialogueMusicReset" then
		Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	end
	if eventName == "ExitDialogueMusicReset" then
		Audio.MusicChange(0, "_OST/Super Mario 64/Title Theme.ogg")
	end
end

function onDraw()
	local redcurtains = Graphics.loadImageResolved("theming_smbxcurtainsred.png")
	Graphics.drawImageWP(redcurtains, -1000, 0, -12)
end