local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if eventName == "CostChangeMusic" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
	end
	if eventName == "BossBegin" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
	end
	
	local costumes
	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|10;g=2")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/117 Room Before Boss.spc|0;g=2.4")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Before Boss.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/Before Boss.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5")
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.7")
		end
	end

	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|10;g=2")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|23;g=2")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/118b Big Boss (No Intro).spc|0;g=2.3")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/King Wart.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Advance/King Wart.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Adventures of Demo/snipers.it")
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/Super Mario Bros 2/King Wart.ogg")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "BossBegin" then
			Audio.MusicChange(1, "_OST/South Park (N64)/South Park Boss Encounter.ogg")
		end
	end
end