local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

function onStart()
	Audio.MusicChange(0, "_OST/Nintendo Land/J_Blf_night.w.48.dspadpcm.ogg")
	Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onEvent()
	if eventName == "BootDialogueMusicReset" then
		Audio.MusicChange(0, "_OST/Nintendo Land/J_Blf_night.w.48.dspadpcm.ogg")
	end
	if eventName == "ExitDialogueMusicReset" then
		Audio.MusicChange(0, "_OST/Nintendo Land/J_Blf_night.w.48.dspadpcm.ogg")
	end
end

function onDraw()
	local bluecurtains = Graphics.loadImageResolved("theming_smbxcurtainsblue.png")
	Graphics.drawImageWP(bluecurtains, 0, 0, -12)
end
