local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
    if eventName == "Bowser Start" then
        Sound.changeMusic("_OST/Super Mario RPG/105 Fight Against Bowser.spc|0;g=2.5", 1)
    end
    if eventName == "Bowser End" then
        Sound.changeMusic("_OST/Super Mario Bros/Castle.spc|0;g=2.5", 1)
    end
end