local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
	if eventName == ("Pigeon Cutscene") then
		if SaveData.disableX2char == false then
			pausemenu.pauseactivated = false
			inventory.activated = false
		end
		if SaveData.disableX2char == true then
			pausemenu.pauseactivated = false
		end
	end
	if eventName == ("Pigeon Cutscene 3") then
		SFX.play("_OST/_Sound Effects/pigeon_attack.ogg")
	end
	if eventName == ("Pigeon Cutscene 5") then
		if SaveData.disableX2char == false then
			pausemenu.pauseactivated = true
			inventory.activated = true
		end
		if SaveData.disableX2char == true then
			pausemenu.pauseactivated = true
		end
		player:teleport(-99936, -100144)
		Timer.activate(150)
	end
	if eventName == ("Pigeon Cutscene Sequel 0") then
		SFX.play("_OST/_Sound Effects/is-the-pool-clean.ogg")
		if SaveData.disableX2char == false then
			pausemenu.pauseactivated = false
			inventory.activated = false
		end
		if SaveData.disableX2char == true then
			pausemenu.pauseactivated = false
		end
		Timer.deactivate()
	end
	if eventName == ("Pigeon Cutscene Sequel 2") then
		SFX.play("_OST/_Sound Effects/pigeon_attack.ogg")
	end
	if eventName == ("Pigeon Cutscene Sequel 3") then
		if SaveData.disableX2char == false then
			pausemenu.pauseactivated = true
			inventory.activated = true
		end
		if SaveData.disableX2char == true then
			pausemenu.pauseactivated = true
		end
	end
end