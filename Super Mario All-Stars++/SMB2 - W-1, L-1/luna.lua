local level_dependencies_smb2 = require("level_dependencies_normal")

local playerManager = require("playerManager")

local costumes = {}

function onStart()
	if player:mem(0x15E, FIELD_WORD) == 7 then
		if currentCostume == nil then
			playSound("smb2-beginning.ogg")
		elseif currentCostume == "4-SMB2-RETRO" then
			playSound("smb1-nes-beginning.ogg")
		elseif currentCostume == "5-SMB2-RETRO" then
			playSound("smb1-nes-beginning.ogg")
		elseif currentCostume == "3-SMB2-RETRO" then
			playSound("smb1-nes-beginning.ogg")
		elseif currentCostume == "IMAJIN-NES" then
			playSound("smb1-nes-beginning.ogg")
		elseif currentCostume == "11-SMA1" then
			playSound("sma1-beginning.ogg")
		elseif currentCostume == "12-SMA2" then
			playSound("sma1-beginning.ogg")
		elseif currentCostume then
			playSound("smb2-beginning.ogg")
		end
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