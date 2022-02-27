local level_dependencies_smb2 = require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onStart()
	if currentCostume == nil then
		Audio.playSFX("_OST/_Sound Effects/smb2-beginning.ogg")
	end
	if currentCostume == "4-SMB2-RETRO" then
		Audio.playSFX("_OST/_Sound Effects/smb1-nes-beginning.ogg")
	end
	if currentCostume == "11-SMA1" then
		Audio.playSFX("_OST/_Sound Effects/sma1-beginning.ogg")
	end
	if currentCostume == "12-SMA2" then
		Audio.playSFX("_OST/_Sound Effects/sma1-beginning.ogg")
	end
end

function onTick()
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	local costumes
	
	if currentCostume == "4-SMB2-RETRO" then
		Audio.MusicChange(0, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
		Audio.MusicChange(1, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
		Audio.MusicChange(5, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
		Audio.MusicChange(6, "_OST/Super Mario Bros 2 (NES) - OST.nsf|2;g=2")
		Audio.MusicChange(7, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
		Audio.MusicChange(8, "_OST/Super Mario Bros 2 (NES) - OST.nsf|3;g=2")
	end
	if currentCostume == "11-SMA1" then
		Audio.MusicChange(0, "_OST/Super Mario Advance/Overworld.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Advance/Overworld.ogg")
		Audio.MusicChange(5, "_OST/Super Mario Advance/Underground.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Advance/Overworld.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance/Jar.ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance/Underground.ogg")
	end
	if currentCostume == "12-SMA2" then
		Audio.MusicChange(0, "_OST/Super Mario Advance/Overworld.ogg")
		Audio.MusicChange(1, "_OST/Super Mario Advance/Overworld.ogg")
		Audio.MusicChange(5, "_OST/Super Mario Advance/Underground.ogg")
		Audio.MusicChange(6, "_OST/Super Mario Advance/Overworld.ogg")
		Audio.MusicChange(7, "_OST/Super Mario Advance/Jar.ogg")
		Audio.MusicChange(8, "_OST/Super Mario Advance/Underground.ogg")
	end
	if currentCostume == "JCFOSTERTAKESITTOTHEMOON" then
		Audio.MusicChange(0, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(1, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(5, "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2.5")
		Audio.MusicChange(6, "_OST/JC Foster Takes it to the Moon/Overworld.spc|0;g=2.5")
		Audio.MusicChange(7, "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2.5")
		Audio.MusicChange(8, "_OST/JC Foster Takes it to the Moon/Its the nutsHACK with loop.spc|0;g=2.5")
	end
	
	if currentCostume == "LARRYTHECUCUMBER" then
		Audio.MusicChange(0, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(1, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(5, "_OST/VeggieTales/Big Things Too.ogg")
		Audio.MusicChange(6, "_OST/VeggieTales/Theme Song.ogg")
		Audio.MusicChange(7, "_OST/VeggieTales/Big Things Too.ogg")
		Audio.MusicChange(8, "_OST/VeggieTales/Big Things Too.ogg")
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
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "BossBegin" then
			Audio.MusicChange(4, "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2")
		end
	end
	if currentCostume == "4-SMB2-RETRO" then
		if eventName == "BossEnd2" then
			Audio.MusicChange(4, "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "BossBegin" then
			Audio.MusicChange(4, "_OST/Super Mario Advance/Boss.ogg")
			SFX.play("costumes/mario/11-SMA1/birdo-thisisasfarasyougo.wav")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "BossEnd1" then
			SFX.play("costumes/mario/11-SMA1/birdo-I'llrememberthis.wav")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "BossEnd2" then
			Audio.MusicChange(4, "_OST/Super Mario Advance/Boss.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "BossBegin" then
			Audio.MusicChange(4, "_OST/Super Mario Advance/Boss.ogg")
		end
	end
	if currentCostume == "12-SMA2" then
		if eventName == "BossEnd2" then
			Audio.MusicChange(4, "_OST/Super Mario Advance/Boss.ogg")
		end
	end
	if eventName == "CostBossChanger2" then
		if currentCostume == "JCFOSTERTAKESITOTHEMOON" then
			Audio.MusicChange(4, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5")
		end
		if currentCostume == "4-SMB2-RETRO" then
			Audio.MusicChange(4, "_OST/Super Mario Bros 2 (NES) - OST.nsf|6;g=2")
		end
		if currentCostume == "11-SMA1" then
			Audio.MusicChange(4, "_OST/Super Mario Advance/Before Boss.ogg")
		end
		if currentCostume == "12-SMA2" then
			Audio.MusicChange(4, "_OST/Super Mario Advance/Before Boss.ogg")
		end
		if currentCostume == nil then
			Audio.MusicChange(4, "_OST/Super Mario Bros 2/Before Boss.spc|0;g=2.5")
		end
	end
end