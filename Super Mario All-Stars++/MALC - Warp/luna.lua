local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
    if player:mem(0x15E, FIELD_WORD) == 1 and player.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 1
        SaveData.smwMap.playerX = -195232
        SaveData.smwMap.playerY = -197856
    end
end
