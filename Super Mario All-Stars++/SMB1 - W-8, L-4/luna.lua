local level_dependencies_normal = require("level_dependencies_normal")
local pauseplus = require("pauseplus")

function onEvent(eventName)
	if eventName == ("Fake Bowser Dead") then
		playSound(138)
	end
	if eventName == ("Real Bowser Dead") then
		playSound(138)
	end
	if eventName == ("Pigeon Cutscene") then
		if SaveData.disableX2char == false then
			furyinventory.activated = false
		end
		pauseplus.canPause = false
	end
	if eventName == ("Pigeon Cutscene 3") then
		playSound("pigeon_attack.ogg")
	end
	if eventName == ("Pigeon Cutscene 5") then
		if SaveData.disableX2char == false then
			furyinventory.activated = true
		end
		pauseplus.canPause = true
		for k,p in ipairs(Player.get()) do
			p:teleport(-99936, -100144)
		end
		Timer.activate(150)
	end
	if eventName == ("Pigeon Cutscene Sequel 0") then
		playSound("is-the-pool-clean.ogg")
		if SaveData.disableX2char == false then
			furyinventory.activated = false
		end
		pauseplus.canPause = false
		Timer.deactivate()
	end
	if eventName == ("Pigeon Cutscene Sequel 2") then
		playSound("pigeon_attack.ogg")
	end
	if eventName == ("Pigeon Cutscene Sequel 3") then
		if SaveData.disableX2char == false then
			furyinventory.activated = true
		end
		pauseplus.canPause = true
	end
end