local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss End") then
        Sound.playSFX(138)
        Sound.changeMusic(0, 2)
        Sound.changeMusic("_OST/Super Mario Bros/Album.spc|0;g=2.5", 1)
    end
end

function onLoadSection0()
    smasNoTurnBack.overrideSection = true
end

function onLoadSection1()
    smasNoTurnBack.overrideSection = false
end

function onLoadSection2()
    smasNoTurnBack.overrideSection = false
end

function onLoadSection3()
    smasNoTurnBack.overrideSection = true
end