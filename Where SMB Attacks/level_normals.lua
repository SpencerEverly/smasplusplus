local levelfolder = Level.folderPath()
local levelname = Level.filename()
local levelformat = Level.format()

local anotherPowerDownLibrary = require("anotherPowerDownLibrary")
local playerphysicspatch = require("playerphysicspatch")
pausemenu = require("pausemenu")

function onStart()
    Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

