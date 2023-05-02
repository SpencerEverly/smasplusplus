local costume = {}
local klonoa = API.load("characters/klonoaa");
local smasFunctions = require("smasFunctions")

function costume.onInit()
    registerEvent(costume, "onDraw");
    klonoa.flapAnimSpeed=3;
    if not costume.loaded then
        Sound.loadCostumeSounds()
        costume.loaded = true
    end
end

function costume.onDraw()
    for _,v in ipairs(Animation.get(152)) do
        v.height = 64;
    end
    
    if(player.holdingNPC) then
        player.holdingNPC.x = player.x-65536;
        player.holdingNPC.y = player.y-65536;
    end
end

function costume.onCleanup(playerObject)
    klonoa.flapAnimSpeed = 6;
end

Misc.storeLatestCostumeData(costume)

return costume