local level_dependencies_normal= require("level_dependencies_normal")
local slm = require("simpleLayerMovement")

slm.addLayer{name = "Moving Platforms",speed = 75,horizontalMovement = slm.MOVEMENT_COSINE,horizontalSpeed = 232,horizontalDistance = 1}

function onEvent(eventName)
    if eventName == "Boss End" then
        Sound.playSFX(20)
    end
end