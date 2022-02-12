local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

function onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if eventName == "Boss Begin" then
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Boss Battle.ogg")
	end
	if eventName == "Boss End" then
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Another World.ogg")
	end
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if eventName == "Boss Begin" then
			Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/Mini Boss.ogg")
		end
		if eventName == "Boss End" then
			Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/ssbb-zelda2.ogg")
		end
	end
end

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/AthleticSMB4.ogg")
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/ssbb-zelda2.ogg")
		Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/AthleticSMB4.ogg")
		Audio.MusicChange(3, "_OST/Super Mario All-Stars++ (Beta)/ssbb-zelda2.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros Spencer/Forest.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Another World.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Bros Spencer/Forest.ogg")
		Audio.MusicChange(3, "_OST/Super Mario Bros Spencer/Another World.ogg")
	end
end