local pm = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

function costume.onInit(p)
    registerEvent(costume,"onDraw")
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    Defines.player_walkspeed = 4
    Defines.player_runspeed = 4
    Defines.jumpheight = 20
    Defines.jumpheight_bounce = 32
    Defines.player_grav = 0.6
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(129)) do
        v.width = 26;
        v.height = 44;
    end
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