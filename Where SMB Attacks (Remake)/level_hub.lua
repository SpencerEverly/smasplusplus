local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

local anotherPowerDownLibrary = require("anotherPowerDownLibrary")

pausemenu_hub = require("pausemenu_hub")

local exitcommands_wsmbaa = require("exitcommands_wsmba")

function onStart()
    Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

