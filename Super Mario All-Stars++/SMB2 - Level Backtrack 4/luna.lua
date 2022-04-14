local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 1 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 1
		SaveData.smwMap.playerX = -198688
		SaveData.smwMap.playerY = -198944
	elseif player:mem(0x15E, FIELD_WORD) == 2 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 2
		SaveData.smwMap.playerX = -198496
		SaveData.smwMap.playerY = -198880
	elseif player:mem(0x15E, FIELD_WORD) == 3 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 3
		SaveData.smwMap.playerX = -198688
		SaveData.smwMap.playerY = -198752
	elseif player:mem(0x15E, FIELD_WORD) == 4 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 4
		SaveData.smwMap.playerX = -198496
		SaveData.smwMap.playerY = -198688
	elseif player:mem(0x15E, FIELD_WORD) == 7 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 5
		SaveData.smwMap.playerX = -198688
		SaveData.smwMap.playerY = -198560
	elseif player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 6
		SaveData.smwMap.playerX = -198496
		SaveData.smwMap.playerY = -198496
	elseif player:mem(0x15E, FIELD_WORD) == 6 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 7
		SaveData.smwMap.playerX = -198688
		SaveData.smwMap.playerY = -198368
	end
end