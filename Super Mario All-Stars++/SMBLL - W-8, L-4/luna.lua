local level_dependencies_normal= require("level_dependencies_normal")

local lightning = require("lightning")
lightning.priority = -99

function onEvent(eventName)
	if eventName == ("Cutscene 4") then
		playSound("pigeon_attack.ogg")
	end
end