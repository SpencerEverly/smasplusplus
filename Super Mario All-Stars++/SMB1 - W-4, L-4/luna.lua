local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss End") then
        Sound.playSFX(138)
        Sound.changeMusic(0, 2)
    end
end

function onLoadSection0()
    smasNoTurnBack.overrideSection = false
end

function onLoadSection1()
    smasNoTurnBack.overrideSection = true
end

function onLoadSection2()
    smasNoTurnBack.overrideSection = true
end

function onLoadSection3()
    smasNoTurnBack.overrideSection = true
end