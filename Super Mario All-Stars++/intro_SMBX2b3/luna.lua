local bootmenu = require("bootmenu")
local littleDialogue = require("littleDialogue")
local rng = API.load("rng")

function onStart()
	local rngnumber = rng.randomInt(1,30)
	Audio.MusicChange(0, "intro_SMBX2b3/trials"..rngnumber..".ogg")
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end