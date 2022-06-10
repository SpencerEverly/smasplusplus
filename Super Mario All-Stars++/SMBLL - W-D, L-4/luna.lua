local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
	if eventName == ("Ending 3") then
		playSound("pigeon_attack.ogg")
	end
end