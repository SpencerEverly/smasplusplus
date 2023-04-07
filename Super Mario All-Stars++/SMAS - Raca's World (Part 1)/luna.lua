local Routine = require("routine")
local littleDialogue = require("littleDialogue")
local smasTrueFinalBossSystem = require("smasTrueFinalBossSystem")

littleDialogue.registerStyle("endingtextone",{
    openSpeed = 1,
    pageScrollSpeed = 1, -- How fast it scrolls when switching pages.
    answerPageScrollSpeed = 1, -- How fast it scrolls when switching answer pages.

    windowingOpeningEffectEnabled = true,

    typewriterEnabled = false,
    showTextWhileOpening = false,

    closeSoundEnabled = false,
    continueArrowEnabled = false,
    scrollArrowEnabled   = false,
    selectorImageEnabled = false,
})

local SmgLifeSystem = require("SmgLifeSystem")
SmgLifeSystem.healthX = 650
SmgLifeSystem.healthY = 10

function onLoadSection0()
    SmgLifeSystem.daredevilActive = false
    SmgLifeSystem.AirMeterActive = false
end

local blacklayer = false

Graphics.activateHud(false)
local invisible = true

function onStart()
    Misc.saveGame()
    player.setCostume(1, nil)
    player:transform(1, false)
end

function onDraw()
    if blacklayer then
        local blackbglayer = Graphics.drawScreen{color = Color.black, priority = 10}
    end
end

function onTick()
    if invisible then
        player:setFrame(50)
    end
end

function onEvent(eventName)
    if eventName == "1" then
        SFX.play("_OST/All Stars Secrets/The True Final Battle Begins (With Screaming, SFX).ogg")
    end
    if eventName == "2" then
        blacklayer = true
    end
    if eventName == "3" then
        blacklayer = false
        invisible = false
        player:teleport(-199632, -200544)
    end
    if eventName == "5" then
        Sound.playSFX("is-the-pool-clean-evilmode.ogg")
    end
    if eventName == "6" then
        Defines.earthquake = 15
        Sound.playSFX("raca-chant.ogg")
        Sound.playSFX("pigeon_attack.ogg")
    end
    if eventName == "7" then
        Audio.MusicChange(0, "_OST/Undertale/mus_f_part1.ogg")
    end
    if eventName == "BattlePreCut1" then
        Sound.playSFX("mus_f_alarm.ogg")
    end
    if eventName == "BattleDodge1" then
        blacklayer = true
        Audio.MusicChange(0, 0)
        player:teleport(-179664, -180272)
        SFX.play("ut_noise.ogg")
    end
    if eventName == "BattleDodge2" then
        blacklayer = false
        SFX.play("ut_noise.ogg")
        player:teleport(-159632, -160224)
        Audio.MusicChange(2, "_OST/Undertale/mus_f_6s_1.ogg")
    end
end