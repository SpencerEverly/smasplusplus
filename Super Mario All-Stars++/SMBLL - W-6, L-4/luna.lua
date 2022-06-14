local level_dependencies_normal = require("level_dependencies_normal")

function onEvent(eventName)
	if eventName == ("Boss End") then
		playSound(138)
	end
	if eventName == "Boss Start" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.0")
	end
end