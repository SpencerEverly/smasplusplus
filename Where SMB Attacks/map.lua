local travL = require("travL")
local wandR = require("wandR")

wandR.speed = 7
travL.showArrows = false

local pausemenu = require("pausemenu_map")

function onStart()
    Misc.saveGame()
end

function onPause(evt)
    evt.cancelled = true;
    isPauseMenuOpen = not isPauseMenuOpen
end

local playerManager = require("playerManager")
playerManager.overworldCharacters = {CHARACTER_MARIO, CHARACTER_LUIGI, CHARACTER_PEACH, CHARACTER_TOAD, CHARACTER_LINK}
