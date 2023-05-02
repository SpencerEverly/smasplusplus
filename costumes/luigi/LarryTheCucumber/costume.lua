local pm = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

function costume.onInit(p)
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    Defines.player_walkspeed = 2.65
    Defines.player_runspeed = 6.1
    Defines.jumpheight = 12
    Defines.jumpheight_bounce = 29.4
    Defines.player_grav = 0.26
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
end

Misc.storeLatestCostumeData(costume)

return costume;