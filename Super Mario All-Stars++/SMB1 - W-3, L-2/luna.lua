local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumes
	if currentCostume == "SP-1-ERICCARTMAN" then
		Audio.MusicChange(0, "_OST/South Park (N64)/The Theme.ogg")
	end
	
	if currentCostume == "SEE-TANGENT" then
		Audio.MusicChange(0, "_OST/Nintendogs/Overworld.ogg")
	end
	if currentCostume == "SONIC" then
		Audio.MusicChange(0, "_OST/Sonic Mania/PulpSolstice1.ogg")
	end
end