local pm = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

local plr

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onTick")
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPlayerHarm")
    registerEvent(costume,"onPostPlayerHarm")
    registerEvent(costume,"onPostNPCKill")
    registerEvent(costume,"onPlayerKill")
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    Defines.jumpheight = 22
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 3
    Defines.jumpheight_bounce = 36
    Defines.projectilespeedx = 7
    Defines.player_grav = 0.38
    
    smasCharacterHealthSystem.enabled = true
    
    costume.abilitesenabled = true
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 3
    Defines.player_runspeed = 6
    Defines.jumpheight_bounce = 32
    Defines.projectilespeedx = 7.1
    Defines.player_grav = 0.4
    
    smasCharacterHealthSystem.enabled = false
    
    costume.abilitesenabled = false
end

Misc.storeLatestCostumeData(costume)

return costume