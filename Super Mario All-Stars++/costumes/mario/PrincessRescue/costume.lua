local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false

function costume.onInit(p)
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    Defines.player_walkspeed = 4
    Defines.player_runspeed = 4
    Defines.jumpheight = 20
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.6
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
end

return costume