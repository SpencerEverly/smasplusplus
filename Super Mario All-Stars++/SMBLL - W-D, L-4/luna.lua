local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss End") then
        Sound.playSFX(138)
    end
    if eventName == ("Ending 3") then
        Sound.playSFX("pigeon_attack.ogg")
    end
end