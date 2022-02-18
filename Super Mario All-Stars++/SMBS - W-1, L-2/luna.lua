local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

function onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumes
	if eventName == "Boss Start" then
		Audio.MusicChange(0, "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5")
		if currentCostume == "0-SMASPLUSPLUS-BETA" then
			Audio.MusicChange(0, "Super Mario All-Stars++ (Beta)/Birdo.ogg")
		end
	end
	if eventName == "Boss End" then
		Audio.MusicChange(0, "_OST/Super Mario Bros Spencer/Athletic.ogg")
		if currentCostume == "0-SMASPLUSPLUS-BETA" then
			Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/AthleticSMB4.ogg")
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
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/Star.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros (NES)/Athletic (SMBS).ogg")
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Star.ogg")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(0, "_OST/Super Mario Bros Spencer/Athletic.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Star.ogg")
	end
end