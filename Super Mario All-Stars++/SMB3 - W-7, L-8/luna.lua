local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Shake Screen" then
        Sound.playSFX(22)
        Defines.earthquake = 5
    end
end

function onLoadSection2()
    autoscrolla.scrollRight(1)
end