local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")

function onStart()
	Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

function onDraw()
	local redcurtains = Graphics.loadImageResolved("theming_smbxcurtainsblue.png")
	Graphics.drawImageWP(redcurtains, 0, 0, -12)
end