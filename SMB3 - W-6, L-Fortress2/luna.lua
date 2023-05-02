local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Boss Start" then
        Screen.setCameraPosition(-179200,-180600,-180000,-178400,1)
        Sound.playSFX(22)
        Sound.changeMusic("_OST/Super Mario Bros 3/Boss.spc|0;g=2.5", 1)
    end
    if eventName == "Boss Start 2" then
        --Sound.playSFX("true-reveal.ogg")
    end
    if eventName == "Boss End" then
        Sound.playSFX("boom-boom-dead-smbx.ogg")
    end
    if eventName == "Boss End 2" then
        Sound.playSFX(20)
    end
end