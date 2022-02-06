local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

local anotherPowerDownLibrary = require("anotherPowerDownLibrary")

pausemenu = require("pausemenu")

local exitcommands_wsmbaa = require("exitcommands_wsmba")

function onStart()
    Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

