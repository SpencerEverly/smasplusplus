local level_dependencies_normal= require("level_dependencies_normal")
local autoscroll = require("autoscroll")

function onEvent(eventName)
    if eventName == "Shake Screen" then
        Sound.playSFX(22)
        Defines.earthquake = 5
    end
end

function onLoadSection0()
    autoscrolla.scrollRight(1)
end