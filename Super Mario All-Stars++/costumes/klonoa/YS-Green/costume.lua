local costume = {}
local klonoa = require("klonoaa");
local colliders = require("colliders")
local playerManager = require("playerManager");
local extrasounds = require("extrasounds")
local smasfunctions = require("smasfunctions")

costume.loadedSounds = false

function costume.onInit()
    registerEvent(costume, "onDraw")
    registerEvent(costume, "onTick")
    klonoa.flapAnimSpeed=3
    ringbox = colliders.Box(0, 0, 32, 32)
    if not costume.loadedSounds then
        Sound.loadCostumeSounds()
        costume.loadedSounds = true
    end
end

function costume.onTick()
    ringbox.y = player.y + 0
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(152)) do
        v.height = 64
    end
    
    if(player.holdingNPC) then
        player.holdingNPC.x = player.x-65536
        player.holdingNPC.y = player.y-65536
    end
end

function costume.onCleanup(playerObject)
    Sound.cleanupCostumeSounds()
    
    klonoa.flapAnimSpeed = 6
    ringbox = colliders.Box(0, 0, 32, 32)
    ringbox.y = player.y + 16
end

return costume