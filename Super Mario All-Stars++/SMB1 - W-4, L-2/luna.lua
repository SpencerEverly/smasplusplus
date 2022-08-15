local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
    Sound.playSFX(139) --Going Underground
end

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 8 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 5
            SaveData.smwMap.playerX = -194112
            SaveData.smwMap.playerY = -199200
        elseif p:mem(0x15E, FIELD_WORD) == 6 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 6
            SaveData.smwMap.playerX = -193280
            SaveData.smwMap.playerY = -199104
        elseif p:mem(0x15E, FIELD_WORD) == 5 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 7
            SaveData.smwMap.playerX = -192416
            SaveData.smwMap.playerY = -199200
        elseif p:mem(0x15E, FIELD_WORD) == 4 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 8
            SaveData.smwMap.playerX = -191712
            SaveData.smwMap.playerY = -199168
        end
    end
end