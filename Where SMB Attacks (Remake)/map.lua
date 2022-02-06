local malcwarp_map_wsmba = require("malcwarp_map_wsmba")

local exitcommands_wsmbaa = require("exitcommands_wsmba")

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
