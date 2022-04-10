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
	elseif player:mem(0x15E, FIELD_WORD) == 4 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 4
		SaveData.smwMap.playerX = -194944
		SaveData.smwMap.playerY = -199136
	elseif player:mem(0x15E, FIELD_WORD) == 8 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 5
		SaveData.smwMap.playerX = -194112
		SaveData.smwMap.playerY = -199200
	elseif player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 6
		SaveData.smwMap.playerX = -193280
		SaveData.smwMap.playerY = -199104
	elseif player:mem(0x15E, FIELD_WORD) == 6 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 7
		SaveData.smwMap.playerX = -192416
		SaveData.smwMap.playerY = -199200
	elseif player:mem(0x15E, FIELD_WORD) == 7 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 8
		SaveData.smwMap.playerX = -191712
		SaveData.smwMap.playerY = -199168
	end
end