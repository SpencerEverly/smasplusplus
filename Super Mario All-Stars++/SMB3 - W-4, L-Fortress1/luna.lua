local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Boss Start" then
        Sound.changeMusic("_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|6;g=2.2", 2)
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
end