local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
	if eventName == "Boss Start" then
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Boss Battle.ogg")
	end
	if eventName == "Boss End" then
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Athletic.ogg")
	end
end