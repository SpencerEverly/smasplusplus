local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
	playSound(139) --Going Underground
end

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 2
		SaveData.smwMap.playerX = -195776
		SaveData.smwMap.playerY = -200352
	end
	if player:mem(0x15E, FIELD_WORD) == 4 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 3
		SaveData.smwMap.playerX = -194976
		SaveData.smwMap.playerY = -200384
	end
	if player:mem(0x15E, FIELD_WORD) == 6 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 4
		SaveData.smwMap.playerX = -194016
		SaveData.smwMap.playerY = -200768
	end
end