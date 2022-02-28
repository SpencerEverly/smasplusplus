local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/AthleticSMB4.ogg")
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/WaterSMB4.ogg")
		Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/AthleticSMB4.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros Spencer/Athletic.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Water.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Bros Spencer/Athletic.ogg")
	end
end

function onEvent(eventName)
	if eventName == "Claps" then
		SFX.play("_OST/_Sound Effects/pcoins-allcollected.ogg")
	end
end