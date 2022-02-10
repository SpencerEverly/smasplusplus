local bootmenu = require("bootmenu")

function onStart()
	Audio.MusicChange(0, "_OST/All Stars Menu/Boot Menu.ogg")
	Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end