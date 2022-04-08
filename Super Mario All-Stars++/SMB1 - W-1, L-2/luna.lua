local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 2
		SaveData.smwMap.playerX = -196480
		SaveData.smwMap.playerY = -199264
	end
end