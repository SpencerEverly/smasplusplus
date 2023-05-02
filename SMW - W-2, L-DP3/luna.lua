local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Platform Switch 1" or eventName == "Platform Switch 2" then
        Sound.playSFX(32)
    end
end