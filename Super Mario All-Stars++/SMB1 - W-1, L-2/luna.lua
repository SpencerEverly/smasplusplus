local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 2
		SaveData.smwMap.playerX = -196480
		SaveData.smwMap.playerY = -199264
	end
	if player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 3
		SaveData.smwMap.playerX = -195776
		SaveData.smwMap.playerY = -199072
	end
	if player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 4
		SaveData.smwMap.playerX = -194944
		SaveData.smwMap.playerY = -199136
	end
end