local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
	if eventName == ("Boss End") then
		playSound(138)
	end
	if eventName == ("Ending 3") then
		playSound("pigeon_attack.ogg")
	end
end