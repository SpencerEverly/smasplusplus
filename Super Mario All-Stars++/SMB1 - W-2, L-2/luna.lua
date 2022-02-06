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
		Audio.MusicChange(1, "_OST/Super Mario All-Stars++ (Beta)/Water.ogg")
		Audio.MusicChange(2, "_OST/Super Mario All-Stars++ (Beta)/Classic.ogg")
	end
	if currentCostume == "1-SMB1-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros (NES) - OST.nsf|2;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros (NES)/Desert.ogg")
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "3-SMB1-SMAS" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "4-SMB2-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES)/Underwater.ogg")
		Audio.MusicChange(2, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
	end
	if currentCostume == "5-SMB2-SMAS" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "6-SMB3-RETRO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|10;g=2")
		Audio.MusicChange(2, "_OST/Super Mario Bros. 3 (NES) - OST.nsf|8;g=2")
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "12-SMA2" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "A2XT-DEMO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "MODERN" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "PRINCESSRESCUE" then
		Audio.MusicChange(1, "_OST/Princess Rescue/Underground.ogg")
		Audio.MusicChange(2, "_OST/Princess Rescue/Overworld.ogg")
	end
	if currentCostume == "SMW-MARIO" then
		Audio.MusicChange(1, "_OST/Super Mario Bros/Swimming.spc|0;g=2.6")
		Audio.MusicChange(2, "_OST/Super Mario Bros/Desert.spc|0;g=2.5")
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		Audio.MusicChange(1, "_OST/South Park (N64)/The Theme.ogg")
		Audio.MusicChange(2, "_OST/South Park (N64)/Warehouse In South Park.ogg")
	end
	
	--CHARACTER_TOAD
	if currentCostume == "SONIC" then
		Audio.MusicChange(1, "_OST/Sonic Mania/OilOcean1.ogg")
		Audio.MusicChange(2, "_OST/Sonic Mania/Hydrocity1.ogg")
	end
end

function onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()

	--Going Underground
	
	if currentCostume == nil then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	
	--CHARACTER_MARIO
	if currentCostume == "0-SMASPLUSPLUS-BETA" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario All-Stars++ (Beta)/Going Underground.ogg")
		end
	end
	if currentCostume == "1-SMB1-RETRO" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros (NES) - OST.nsf|10;g=2")
		end
	end
	if currentCostume == "2-SMB1-RECOLORED" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "3-SMB1-SMAS" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "5-SMB2-SMAS" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "6-SMB3-RETRO" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "Z-SMW2-ADULTMARIO" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "Level - Start" then
			SFX.play("_OST/_OST/Super Mario Advance 4/Going Underground.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Advance 4/Going Underground.ogg")
		end
	end
	if currentCostume == "14-NSMBDS-SMBX" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "15-NSMBDS-ORIGINAL" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "A2XT-DEMO" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Adventures of Demo/Going Underground.ogg")
		end
	end
	if currentCostume == "MODERN" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "PRINCESSRESCUE" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Princess Rescue/Going Underground.ogg")
		end
	end
	if currentCostume == "SMW-MARIO" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Super Mario Bros/Going Underground.spc|0;g=2.5")
		end
	end
	if currentCostume == "SP-1-ERICCARTMAN" then
		if eventName == "Level - Start" then
			SFX.play("_OST/South Park/Going Underground.ogg")
		end
	end
	
	--CHARACTER_TOAD
	if currentCostume == "SONIC" then
		if eventName == "Level - Start" then
			SFX.play("_OST/Sonic Mania/Going Underground.ogg")
		end
	end
end