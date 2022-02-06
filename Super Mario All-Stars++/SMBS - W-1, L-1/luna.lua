local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/Overworld.ogg")
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/Special Stage.ogg")
		Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/Star.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros Spencer/Overworld.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Caves.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Bros Spencer/Star.ogg")
	end
end