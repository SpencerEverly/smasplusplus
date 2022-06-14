local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
	playSound(139) --Going Underground
end

function onExit()
	if player:mem(0x15E, FIELD_WORD) == 5 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 7
		SaveData.smwMap.playerX = -192320
		SaveData.smwMap.playerY = -200352
	end
	if player:mem(0x15E, FIELD_WORD) == 4 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 8
		SaveData.smwMap.playerX = -191488
		SaveData.smwMap.playerY = -200992
	end
end