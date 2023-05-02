local level_dependencies_normal= require("level_dependencies_normal")
local clearpipe2 = require("clearpipe2")

function onStart()
    for i = 1, NPC_MAX_ID do
        clearpipe2.unregisterNPC(i)
    end
end

function onEvent(eventName)
    if eventName == "Shake Screen" then
        Sound.playSFX(22)
        Defines.earthquake = 5
    end
end