local battledependencies = require("classicbattlemode")
battledependencies.battlemodeactive = true

function onEvent(eventName)
    if eventName == "Hit Plunger" then
        Sound.changeMusic("_OST/Super Mario RPG/105 Fight Against Bowser.spc|0;g=2.5", 0)
    end
end