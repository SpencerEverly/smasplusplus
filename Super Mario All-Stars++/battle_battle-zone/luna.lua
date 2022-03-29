level_dependencies_classicbattle = require("level_dependencies_classicbattle")

function onEvent(eventName)
	if eventName == "Hit Plunger" then
		Audio.MusicChange(0, "_OST/Super Mario RPG/105 Fight Against Bowser.spc|0;g=2.5")
	end
end