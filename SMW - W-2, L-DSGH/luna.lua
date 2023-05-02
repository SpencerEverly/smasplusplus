local level_dependencies_normal= require("level_dependencies_normal")

local slopes = require("slopes")
slopes.jump_through = {752, 753}

function onEvent(eventName)
    if eventName == "Boss End" then
        Sound.playSFX(20)
    end
end