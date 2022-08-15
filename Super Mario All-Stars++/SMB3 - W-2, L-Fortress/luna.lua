local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Boss Start" then
        Sound.changeMusic("_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|6;g=2.2", 1)
    end
    if eventName == "Boss Start 2" then
        SFX.play("true-reveal.ogg")
    end
    if eventName == "Boss Dead" then
        SFX.play("boom-boom-dead-smbx.ogg")
    end
end