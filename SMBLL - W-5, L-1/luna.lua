local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 6 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 6
            SaveData.smwMap.playerX = -193216
            SaveData.smwMap.playerY = -200224
        end
    end
end