local playerManager = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasHud = require("smasHud")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

local plr

function costume.onInit(p)
    plr = p
    registerEvent(costume,"onDraw")
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    smasCharacterHealthSystem.enabled = true
end

function costume.onDraw()
    if plr.powerup >= 3 then
        plr.powerup = 2
    end
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    smasCharacterHealthSystem.enabled = false
end

Misc.storeLatestCostumeData(costume)

return costume