local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Boss Begin (Part 1)" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 5)
    end
    if eventName == "Boss Dead -1 (Part 0)" then
        Sound.changeMusic(0, 5)
        Sound.playSFX(41)
    end
    if eventName == "Boss Dead (Part 1)" then
        Sound.changeMusic(0, 5)
    end
    if eventName == "Boss Dead 2 (Part 1)" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 5)
    end
    if eventName == "Boss End (Part 2)" then
        Sound.changeMusic(0, 5)
    end
    if eventName == "BossBeginPart 2" then
        Sound.changeMusic("_OST/Super Mario Bros 2/King Wart.ogg", 5)
    end
    if eventName == "True Boss End 1" then
        Sound.playSFX("ace-coins-5.ogg")
    end
end