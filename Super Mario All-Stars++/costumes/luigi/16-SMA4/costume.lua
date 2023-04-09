local pm = require("playerManager")
local extrasounds = require("extrasounds")
local smasFunctions = require("smasFunctions")

local costume = {}

costume.loadedSounds = false

function costume.onInit(p)
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
end

function costume.onCleanup(p)
    Sound.cleanupCostumeSounds()
end

return costume;