local playerManager = require("playerManager")
local smasExtraSounds = require("smasExtraSounds")
local smasFunctions = require("smasFunctions")

local costume = {}

local plr

costume.loaded = false

function costume.onInit(p)
    plr = p
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
    
    --smasCharacterHealthSystem.enabled = true --Only for heart-related Mario/Luigi characters!
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
    
    --smasCharacterHealthSystem.enabled = false --Only for heart-related Mario/Luigi characters!
end

Misc.storeLatestCostumeData(costume)

return costume