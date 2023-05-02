local level_dependencies_normal = require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Level Timer - End" then
        Sound.playSFX("battle-start.ogg")
        Audio.MusicChange(0, 0)
    end
    if eventName == "Level Timer - End 3" then
        Level.load("MALC - HUB.lvlx", nil, 39)
    end
end