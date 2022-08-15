local level_dependencies_normal= require("level_dependencies_normal")
local furyinventory = require("furyinventory")
local flipperino = require("flipperino")
local pauseplus = require("pauseplus")

function onEvent(eventName)
    if eventName == "flip" then
        SFX.play("ender_portal.ogg")
    end
    if eventName == "flipNormal" then
        SFX.play("ender_portal.ogg")
    end
    if eventName == "Cutscene 1" then
        if SaveData.disableX2char == false then
            pauseplus.canPause = false
            furyinventory.activated = false
        end
        if SaveData.disableX2char == true then
            pauseplus.canPause = false
        end
    end
    if eventName == "Cutscene 2 - 5" then
        SFX.play("_OST/Undertale/mus_rimshot_smbxsfx.ogg")
    end
    if eventName == "Cutscene 2 - 9" then
        SFX.play("ut_noise.ogg")
    end
    if eventName == "Cutscene 2 - 10" then
        SFX.play("ut_noise.ogg")
    end
    if eventName == "Cutscene 2 - 13" then
        if SaveData.disableX2char == false then
            pauseplus.canPause = true
            furyinventory.activated = true
        end
        if SaveData.disableX2char == true then
            pauseplus.canPause = true
        end
    end
end