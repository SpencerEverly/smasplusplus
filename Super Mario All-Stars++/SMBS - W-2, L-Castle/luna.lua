local level_dependencies_normal= require("level_dependencies_normal")

local inOtherArea = false

function onLoadSection0()
    inOtherArea = false
end

function onLoadSection1()
    inOtherArea = true
end

function onLoadSection2()
    inOtherArea = false
end

function onLoadSection3()
    inOtherArea = false
end

function onEvent(eventName)
    if inOtherArea then
        if eventName == "Quicksand Timer 2" or eventName == "Quicksand Timer 3" or eventName == "Quicksand Timer 4" or eventName == "Quicksand Timer 6" or eventName == "Quicksand Timer 7" or eventName == "Quicksand Timer 8" then
            Sound.playSFX("startsmasboot-timerbeep.ogg")
        end
        if eventName == "Quicksand Timer 5" or eventName == "Quicksand Timer 9" then
            Sound.playSFX("startsmasboot-executed.ogg")
        end
    end
    if eventName == "Boss Start" then
        if SaveData.SMASPlusPlus.game.onePointThreeModeActivated then
            for _,p in ipairs(Player.get()) do
                p:teleport(-139904, -140108)
            end
        end
    end
end