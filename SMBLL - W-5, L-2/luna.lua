local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
    for _,p in ipairs(Player.get()) do
        if SysManager.getEnteredCheckpointID() == 0 and p:mem(0x15E, FIELD_WORD) == 0 then
            Sound.playSFX(139) --Going Underground
        end
    end
end

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 5 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 7
            SaveData.smwMap.playerX = -192320
            SaveData.smwMap.playerY = -200352
        end
        if p:mem(0x15E, FIELD_WORD) == 4 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World 8
            SaveData.smwMap.playerX = -191488
            SaveData.smwMap.playerY = -200992
        end
    end
end