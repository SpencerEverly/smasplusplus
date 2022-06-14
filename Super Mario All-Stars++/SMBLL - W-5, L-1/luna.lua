local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 6 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 6
		SaveData.smwMap.playerX = -193216
		SaveData.smwMap.playerY = -200224
	end
end