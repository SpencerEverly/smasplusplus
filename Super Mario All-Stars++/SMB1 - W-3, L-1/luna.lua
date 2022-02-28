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
		Audio.MusicChange(1, "_OST/South Park (N64)/Banjo Barnyard.ogg")
		Audio.MusicChange(2, "_OST/South Park (N64)/Caves Of South Park.ogg")
	end
	
	if currentCostume == "SEE-TANGENT" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Snow.spc|0;g=2.5") --wip
		Audio.MusicChange(1, "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
	end
	if currentCostume == "SONIC" then
		Audio.MusicChange(0, "_OST/Sonic Mania/PulpSolstice1.ogg")
		Audio.MusicChange(1, "_OST/Sonic Mania/BlueSpheres.ogg")
		Audio.MusicChange(2, "_OST/Sonic Mania/FlyingBattery1.ogg")
	end
end