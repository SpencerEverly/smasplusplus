local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
	if eventName == ("Pigeon Cutscene 3") then
		SFX.play("pigeon_attack.ogg")
	end
	if eventName == ("Pigeon Cutscene 5") then
		player:teleport(-99936, -100144)
		Timer.activate(150)
	end
	if eventName == ("Pigeon Cutscene Sequel 2") then
		SFX.play("pigeon_attack.ogg")
		Timer.deactivate()
	end
end