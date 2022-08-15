local level_dependencies_normal= require("level_dependencies_normal")

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 1 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World C
            SaveData.smwMap.playerX = -195712
            SaveData.smwMap.playerY = -200960
        end
    end
end