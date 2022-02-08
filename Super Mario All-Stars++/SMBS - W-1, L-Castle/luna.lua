local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

function onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if eventName == "Mario Talk 1" then
		--SFX.play("mariotalk1-smbs.wav")
		return
	end
end

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/CastleSMB4.ogg")
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/CastleSMB4.ogg")
		Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/CastleSMB4.ogg")
		Audio.MusicChange(3, "_OST/Super Mario All-Stars++ (Beta)/CastleSMB4.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros Spencer/Castle.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Bros Spencer/Castle.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Bros Spencer/Castle.ogg")
		Audio.MusicChange(3, "_OST/Super Mario Bros Spencer/Castle.ogg")
	end
end