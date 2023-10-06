local level_dependencies_normal= require("level_dependencies_normal")
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
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            if SaveData.SMASPlusPlus.accessibility.enableAdditionalInventory then
                smasBooleans.toggleOffInventory = true
            end
        end
        pauseplus.canPause = false
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
        if not SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            if SaveData.SMASPlusPlus.accessibility.enableAdditionalInventory then
                smasBooleans.toggleOffInventory = false
            end
        end
        pauseplus.canPause = true
    end
end