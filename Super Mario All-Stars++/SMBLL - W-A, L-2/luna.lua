local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
	playSound(139) --Going Underground
end

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 3 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World B
		SaveData.smwMap.playerX = -195424
		SaveData.smwMap.playerY = -200896
	end
end