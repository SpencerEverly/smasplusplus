local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Claps" then
        Sound.playSFX("pcoins-allcollected.ogg")
    end
end