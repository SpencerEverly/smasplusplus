local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
    Sound.playSFX(139) --Going Underground
end

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 5 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 2
            SaveData.smwMap.playerX = -196480
            SaveData.smwMap.playerY = -199264
        end
        if p:mem(0x15E, FIELD_WORD) == 6 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 3
            SaveData.smwMap.playerX = -195776
            SaveData.smwMap.playerY = -199072
        end
        if p:mem(0x15E, FIELD_WORD) == 7 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 4
            SaveData.smwMap.playerX = -194944
            SaveData.smwMap.playerY = -199136
        end
    end
end