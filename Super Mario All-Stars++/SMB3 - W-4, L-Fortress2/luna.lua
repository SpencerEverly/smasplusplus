local level_dependencies_normal= require("level_dependencies_normal")
local clearpipe2 = require("clearpipe2")

function onStart()
    for i = 1, NPC_MAX_ID do
        clearpipe2.unregisterNPC(i)
    end
end

function onEvent(eventName)
    if eventName == "Boss Start" then
        Sound.playSFX(22)
        Sound.changeMusic("_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|6;g=2.2", 0)
    end
    if eventName == "Boss Start 2" then
        Sound.playSFX("true-reveal.ogg")
    end
    if eventName == "Boss End" then
        Sound.playSFX("boom-boom-dead-smbx.ogg")
    end
    if eventName == "Boss End 2" then
        Sound.playSFX(20)
    end
    
    if eventName == "Shake Screen" then
        Sound.playSFX(22)
        Defines.earthquake = 5
    end
end