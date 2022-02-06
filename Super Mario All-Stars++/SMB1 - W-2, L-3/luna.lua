local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2")
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if currentCostume == "3-SMB1-SMAS" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if currentCostume == "4-SMB2-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Sky.ogg")
	end
	if currentCostume == "5-SMB2-SMAS" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if currentCostume == "6-SMB3-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|9;g=2")
	end
	if currentCostume == "10-SMW2-ADULTMARIO" then
		Audio.MusicChange(0, "_OST/Super Mario World 2 - Yoshi's Island/113 Athletic.spc|0;g=2.5")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
	end
	if currentCostume == "12-SMA2" then
		Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if currentCostume == "A2XT-DEMO" then
		Audio.MusicChange(0, "_OST/Adventures of Demo/humble_down_theroad.mod")
	end
	if currentCostume == "MODERN" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if currentCostume == "PRINCESSRESCUE" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if currentCostume == "SMW-MARIO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Athletic.spc|0;g=2.5")
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		Audio.MusicChange(0, "_OST/South Park (N64)/Insane Toys.ogg")
	end
	
	if currentCostume == "SEE-TANGENT" then
		Audio.MusicChange(0, "_OST/Nintendogs/Athletic.ogg")
	end
	if currentCostume == "SONIC" then
		Audio.MusicChange(0, "_OST/Sonic Mania/Hydrocity2.ogg")
	end
end