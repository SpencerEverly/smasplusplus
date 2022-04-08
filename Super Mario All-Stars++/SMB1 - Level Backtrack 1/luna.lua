local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 1 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 1
		SaveData.smwMap.playerX = -197440
		SaveData.smwMap.playerY = -199264
	elseif player:mem(0x15E, FIELD_WORD) == 2 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 2
		SaveData.smwMap.playerX = -196480
		SaveData.smwMap.playerY = -199264
	elseif player:mem(0x15E, FIELD_WORD) == 3 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 3
		SaveData.smwMap.playerX = -195776
		SaveData.smwMap.playerY = -199072
	end
end