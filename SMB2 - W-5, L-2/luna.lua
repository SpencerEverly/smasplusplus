local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
    local character = player.character
    if (character == CHARACTER_YOSHI) then
        triggerEvent("POWFailsafe")
    end
end

function onEvent(eventName)
    if eventName == "Boss Start" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 5)
    end
    if eventName == "Boss End" then
        Sound.changeMusic(0, 5)
        Sound.playSFX(40)
    end
    if eventName == "Boss End 2" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 5)
    end
end