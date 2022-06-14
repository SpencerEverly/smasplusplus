local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 1 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 1
		SaveData.smwMap.playerX = -198080
		SaveData.smwMap.playerY = -200256
	elseif player:mem(0x15E, FIELD_WORD) == 2 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 2
		SaveData.smwMap.playerX = -195776
		SaveData.smwMap.playerY = -200352
	elseif player:mem(0x15E, FIELD_WORD) == 3 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 3
		SaveData.smwMap.playerX = -194976
		SaveData.smwMap.playerY = -200384
	elseif player:mem(0x15E, FIELD_WORD) == 4 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 4
		SaveData.smwMap.playerX = -194016
		SaveData.smwMap.playerY = -200768
	elseif player:mem(0x15E, FIELD_WORD) == 8 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 5
		SaveData.smwMap.playerX = -194176
		SaveData.smwMap.playerY = -200256
	elseif player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 6
		SaveData.smwMap.playerX = -193216
		SaveData.smwMap.playerY = -200224
	elseif player:mem(0x15E, FIELD_WORD) == 6 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 7
		SaveData.smwMap.playerX = -192320
		SaveData.smwMap.playerY = -200352
	elseif player:mem(0x15E, FIELD_WORD) == 7 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 8
		SaveData.smwMap.playerX = -191488
		SaveData.smwMap.playerY = -200992
	end
end
