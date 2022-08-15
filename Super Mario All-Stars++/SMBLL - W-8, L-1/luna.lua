local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 3 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 9
            SaveData.smwMap.playerX = -192320
            SaveData.smwMap.playerY = -200928
        end
    end
end