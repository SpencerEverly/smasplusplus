local level_dependencies_smb2 = require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onStart()
	if currentCostume == nil then
		Audio.playSFX("_OST/_Sound Effects/smb2-beginning.ogg")
	end
	if currentCostume then
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

function onEvent(eventName)
	local character = player.character;
	local costumes = playerManager.getCostumes(player.character)
	local currentCostume = player:getCostume()
	
	if eventName == "Boss Start" then
		Audio.MusicChange(4, "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5")
	end
	if eventName == "Boss End 2" then
		Audio.MusicChange(4, "_OST/Super Mario Bros 2/Boss.spc|0;g=2.5")
	end
	
	local costumes
	if currentCostume == "11-SMA1" then
		if eventName == "Boss Start" then
			playSound("mario/11-SMA1/birdo-thisisasfarasyougo.wav")
		end
	end
	if currentCostume == "11-SMA1" then
		if eventName == "Boss End" then
			playSound("mario/11-SMA1/birdo-I'llrememberthis.wav")
		end
	end
end