local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss End") then
        Sound.playSFX(138)
        Sound.changeMusic(0, 2)
    end
end

function onLoadSection0()
    smasnoturnback.overrideSection = true
end

function onLoadSection1()
    smasnoturnback.overrideSection = false
end

function onLoadSection2()
    smasnoturnback.overrideSection = false
end

function onLoadSection3()
    smasnoturnback.overrideSection = true
end