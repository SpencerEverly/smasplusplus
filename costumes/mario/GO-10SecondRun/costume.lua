local pm = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

local plr

function costume.onInit(p)
    plr = p
    
    registerEvent(costume,"onDraw")
    registerEvent(costume,"onPostPlayerKill")
    
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    Defines.jumpheight = 20
    Defines.player_walkspeed = 5
    Defines.player_runspeed = 5
    Defines.jumpheight_bounce = 24
    Defines.projectilespeedx = 6.2
    Defines.player_grav = 0.28
    
    smasCharacterHealthSystem.enabled = true
    costume.abilitesenabled = true
    
    Routine = require("routine")
end

function costume.onDraw()
    if plr.powerup >= 3 then
        plr.powerup = 2
    end
end

function costume.onPostPlayerKill()
    Sound.playSFX("mario/GO-10SecondRun/fanfares/go-game-over.ogg")
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
end

Misc.storeLatestCostumeData(costume)

return costume