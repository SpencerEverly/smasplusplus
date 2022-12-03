local pm = require("playerManager")
local Routine = require("routine")
local extrasounds = require("extrasounds")
_G.smasfunctions = require("smasfunctions")

local costume = {}

costume.loadedSounds = false

function costume.onInit(p)
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    Defines.player_walkspeed = 4.0
    Defines.player_runspeed = 4.0
    Defines.jumpheight = 15
    Defines.jumpheight_bounce = 16
    Defines.player_grav = 0.35
end

function costume.onCleanup(p)
    for i = 1,91 do
        Audio.sounds[i].sfx = nil
    end
    for i = 1,165 do
        extrasounds.sound.sfx[i] = nil
    end
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.4
end

return costume