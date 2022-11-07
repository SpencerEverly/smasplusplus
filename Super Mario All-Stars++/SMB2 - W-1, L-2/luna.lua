local level_dependencies_smb2 = require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Boss Start" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 1)
    end
    if eventName == "Boss End" then
        Sound.changeMusic(0, 1)
        Sound.playSFX(40)
    end
    if eventName == "Boss End 2" then
        Sound.changeMusic("_OST/Super Mario Bros 2/Boss.spc|0;g=2.5", 1)
    end
end