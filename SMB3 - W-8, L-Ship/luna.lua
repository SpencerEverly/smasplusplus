local level_dependencies_normal = require("level_dependencies_normal")

function onLoadSection0()
    autoscrolla.scrollRight(1)
end

function onEvent(eventName)
    if eventName == "Boss End" then
        Sound.playSFX(20)
    end
end