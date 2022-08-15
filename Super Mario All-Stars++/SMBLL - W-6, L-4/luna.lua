local level_dependencies_normal = require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == ("Boss End") then
        Sound.playSFX(138)
    end
    if eventName == "Boss Start" then
        Sound.changeMusic("_OST/Super Mario Bros/Bowser.spc|0;g=2.0", 0)
    end
end