local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Boss Start" then
        Sound.changeMusic("_OST/Super Mario Bros 3/Boss.spc|0;g=2.5", 2)
    end
    if eventName == "Boss End" then
        SFX.play("boom-boom-dead-smbx.ogg")
    end
end