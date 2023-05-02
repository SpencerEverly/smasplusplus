local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Boss End" then
        Sound.changeMusic(0, 1)
    end
    if eventName == "Boss End 2" then
        Sound.playSFX(120)
    end
end