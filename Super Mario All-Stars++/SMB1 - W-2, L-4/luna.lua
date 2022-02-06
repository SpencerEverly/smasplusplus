local level_dependencies_normal= require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	--CHARACTER_MARIO
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
		Audio.MusicChange(2, "_OST/Super Mario All Stars++ (Beta)/Lineland.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros (NES) - OST.nsf|0;g=2")
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "3-SMB1-SMAS" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "4-SMB2-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
	end
	if currentCostume == "5-SMB2-SMAS" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "6-SMB3-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|15;g=2")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		Audio.MusicChange(1, "_OST/Super Mario World 2 - Yoshi's Island/107 Flower Garden.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(1, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "12-SMA2" then
		Audio.MusicChange(1, "_OST/Super Mario Advance 4/Super Mario Brothers Normal Level.ogg")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		Audio.MusicChange(1, "_OST/New Super Mario Bros. DS/Walking the Plains.ogg")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "A2XT-DEMO" then
		Audio.MusicChange(1, "_OST/Adventures of Demo/asmt-imperial.spc|0;g=2.5")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "MODERN" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "PRINCESSRESCUE" then
		Audio.MusicChange(1, "_OST/Princess Rescue/Overworld.ogg")
		Audio.MusicChange(2, "_OST/Princess Rescue/Overworld.ogg")
	end
	if currentCostume == "SMW-MARIO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		Audio.MusicChange(1, "_OST/South Park (N64)/Insane Toys.ogg")
		Audio.MusicChange(2, "_OST/South Park (N64)/Operation Turkey Butt.ogg")
	end
	
	--CHARACTER_TOAD
	if currentCostume == "SEE_TANGENT" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Album.spc|0;g=2.7")
		Audio.MusicChange(2, "_OST/All Stars Secrets/Lineland.ogg")
	end
	if currentCostume == "SONIC" then
		Audio.MusicChange(1, "_OST/Sonic Mania/Hydrocity2.ogg")
		Audio.MusicChange(2, "_OST/Sonic Mania/BlueSpheres.ogg")
	end
end

function onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if eventName == "BossBegin" then
		Audio.MusicChange(4, "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5")
	end
	if eventName == "BossEnd2" then
		Audio.MusicChange(4, "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5")
	end
	
	local costumes
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario All Stars++ (Beta)/Castle.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2, Beta (NES) - OST.nsf|2;g=2")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|22;g=2")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario World 2 - Yoshi's Island/110 Castle & Fortress.spc|0;g=2.5")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Advance/Castle.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 4/Super Mario Brothers Castle.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/time_is_running.spc|0;g=2.5")
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Princess Rescue/Underground.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Castle.spc|0;g=2.6")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/South Park (N64)/Mad Robots.ogg")
		end
	end
	
	--CHARACTER_TOAD
	
	if currentCostume == "SONIC" then
		if eventName == "CostChangeMusic" then
			Audio.MusicChange(0, "_OST/Sonic Mania/FlyingBattery2.ogg")
		end
	end
	
	--Boss Start
	
	--CHARACTER_MARIO
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario All Stars++ (Beta)/SMBDDX - Bowser Battle.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Bros (NES) - OST.nsf|3;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|21;g=2")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario World 2 - Yoshi's Island/118b Big Boss (No Intro).spc|0;g=2.3")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Advance/Boss.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Advance 2/Boss Battle.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/New Super Mario Bros. DS/Castle Boss.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Adventures of Demo/time_is_running.spc|0;g=2.5")
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Princess Rescue/Underground.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Super Mario Bros/Bowser.spc|0;g=2.5")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/South Park (N64)/South Park Boss Encounter.ogg")
		end
	end
	
	--CHARACTER_TOAD
	if currentCostume == "SONIC" then
		if eventName == "Boss Start" then
			Audio.MusicChange(0, "_OST/Sonic Mania/BossEggman1.ogg")
		end
	end
	
	--Boss End
	
	--CHARACTER_MARIO
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario All-Stars++ (Beta)/Clear!.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Bros (NES) - OST.nsf|6;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Bros 2 (NES) - OST.nsf|11;g=2")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Bros 3 (NES) - OST.nsf|28;g=2")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario World 2 - Yoshi's Island/119 Big Boss Clear.spc|0;g=2.5")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Advance/Boss Cleared.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Advance 2/Fortress Clear.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "Boss End" then
			SFX.play("_OST/New Super Mario Bros. DS/gameClear.ogg")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "Boss End" then
			SFX.play("_OST/New Super Mario Bros. DS/gameClear.ogg")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "Boss End" then
			SFX.play("_OST/Adventures of Demo/Game Beat!.ogg")
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "Boss End" then
			SFX.play("_OST/Princess Rescue/Course Clear!.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "Boss End" then
			SFX.play("_OST/Super Mario Bros/World Clear.spc|0;g=2.5")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "Boss End" then
			SFX.play("_OST/South Park/Banjo Lick.ogg")
		end
	end
	
	--CHARACTER_TOAD
	
	if currentCostume == "SONIC" then
		if eventName == "Boss End" then
			SFX.play("_OST/Sonic Mania/ActClear.ogg")
		end
	end
end