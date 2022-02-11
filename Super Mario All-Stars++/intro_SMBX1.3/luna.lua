local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

function onStart()
	Audio.MusicChange(0, 56)
	Misc.saveGame()
end

function onEvent()
	if eventName == "BootDialogueMusicReset" then
		Audio.MusicChange(0, 56)
	end
	if eventName == "ExitDialogueMusicReset" then
		Audio.MusicChange(0, 56)
	end
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onDraw()
	local bluecurtains = Graphics.loadImageResolved("theming_smbxcurtainsblue.png")
	Graphics.drawImageWP(bluecurtains, 0, 0, -12)
end