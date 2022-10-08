local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smasfunctions
pcall(function() smasfunctions = require("smasfunctions") end)

local costume = {}

costume.loadedSounds = false

function costume.onInit(p)
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
    
    Defines.player_walkspeed = 2.65
    Defines.player_runspeed = 6.1
    Defines.jumpheight = 12
    Defines.jumpheight_bounce = 29.4
    Defines.player_grav = 0.26
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

return costume;