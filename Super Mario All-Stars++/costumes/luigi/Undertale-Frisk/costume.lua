local pm = require("playerManager")
local Routine = require("routine")
local extrasounds = require("extrasounds")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

function costume.onInit(p)
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    Defines.player_walkspeed = 4.0
    Defines.player_runspeed = 4.0
    Defines.jumpheight = 15
    Defines.jumpheight_bounce = 16
    Defines.player_grav = 0.35
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

return costume