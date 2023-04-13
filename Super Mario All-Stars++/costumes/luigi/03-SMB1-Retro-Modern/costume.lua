local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loaded = false

function costume.onInit(p)
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
end

Misc.storeLatestCostumeData(costume)

return costume