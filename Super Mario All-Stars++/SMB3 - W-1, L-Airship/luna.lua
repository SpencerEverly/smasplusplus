local level_dependencies_normal= require("level_dependencies_normal")

local littleDialogue = require("littleDialogue")

littleDialogue.typewriterEnabled = true

local autoscroll = require("autoscroll")

local airshipScroll = require("airshipScroll")

function onStart()
    if player:mem(0x15E, FIELD_WORD) == 0 and SysManager.getEnteredCheckpointID() == 0 then
        triggerEvent("Beginning Message 0")
    end
end

function onLoadSection2()
    autoscrolla.scrollRight(1)
end

function onEvent(eventName)
    if eventName == "Airship Begin" then
        Sound.playSFX(27)
    end
    if eventName == "Door Forms" then
        Sound.playSFX(20)
    end
end