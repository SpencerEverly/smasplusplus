local level_dependencies_normal= require("level_dependencies_normal")

function onEvent(eventName)
	if eventName == ("Boss End") then
		playSound(138)
	end
end

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 6 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World D
		SaveData.smwMap.playerX = -195424
		SaveData.smwMap.playerY = -201024
	end
end