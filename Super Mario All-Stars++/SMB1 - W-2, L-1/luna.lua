local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumes
	if currentCostume == nil then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
	end
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(0, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/Star Power.ogg")
		Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/Bonus.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros (NES)/Desert.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Bros (NES)/Sky.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
	end
	if currentCostume == "3-SMB1-SMAS" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
	end
	if currentCostume == "4-SMB2-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES)/Desert.ogg")
	end
	if currentCostume == "5-SMB2-SMAS" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
	end
	if currentCostume == "6-SMB3-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2")
		Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|12;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|11;g=2")
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		Audio.MusicChange(0, "_OST/Super Mario World 2 - Yoshi's Island/114 Overworld.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/122 Powerful Infant.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Super Mario World 2 - Yoshi's Island/109 Underground.spc|0;g=2.5")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Advance 4/The Tree Skies.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Advance 4/Underground Level.ogg")
	end
	if currentCostume == "12-SMA2" then
		Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Advance 4/The Tree Skies.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Advance 4/Underground Level.ogg")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg")
		Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Bonus Stage.ogg")
		Audio.MusicChange(2, "_OST/New Super Mario Bros. DS/Underground Theme.ogg")
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Walking the Hot Desert.ogg")
		Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Bonus Stage.ogg")
		Audio.MusicChange(2, "_OST/New Super Mario Bros. DS/Underground Theme.ogg")
	end
	if currentCostume == "A2XT-DEMO" then
		Audio.MusicChange(0, "_OST/Adventures of Demo/happyska.it")
		Audio.MusicChange(1, "_OST/Adventures of Demo/Subway_spc.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/Adventures of Demo/Medivo.spc|0;g=2.5")
	end
	if currentCostume == "MODERN" then
		Audio.MusicChange(0, "_OST/Modern Mario/Desert (VRC6 by TrojanHorse711).nsf|0;g=2.2")
		Audio.MusicChange(1, "_OST/Modern Mario/Staff Roll (VRC6 by TrojanHorse711).nsf|0;g=2.2")
		Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES, VRC6 by skydev) - OST.nsf|9;g=2.7")
	end
	if currentCostume == "PRINCESSRESCUE" then
		Audio.MusicChange(0, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(1, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(2, "_OST/Princess Rescue/Underground.ogg")
	end
	if currentCostume == "SMW-MARIO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		Audio.MusicChange(0, "_OST/South Park (N64)/Warehouse In South Park.ogg")
		Audio.MusicChange(1, "_OST/South Park (N64)/Banjo Barnyard.ogg")
		Audio.MusicChange(2, "_OST/South Park (N64)/Caves Of South Park.ogg")
	end
	
	if currentCostume == "SEE-TANGENT" then
		Audio.MusicChange(0, "_OST/Super Mario Bros/Desert.spc|0;g=2.5") --wip
		Audio.MusicChange(1, "_OST/Super Mario Bros/Staff Roll.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Bonus.spc|0;g=2.7")
	end
	if currentCostume == "SONIC" then
		Audio.MusicChange(0, "_OST/Sonic Mania/Hydrocity1.ogg")
		Audio.MusicChange(1, "_OST/Sonic Mania/BlueSpheres.ogg")
		Audio.MusicChange(2, "_OST/Sonic Mania/FlyingBattery1.ogg")
	end
end