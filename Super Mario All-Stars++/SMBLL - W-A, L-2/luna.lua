local level_dependencies_normal= require("level_dependencies_normal")

function onStart()
    Sound.playSFX(139) --Going Underground
end

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 3 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMBLL World B
            SaveData.smwMap.playerX = -195424
            SaveData.smwMap.playerY = -200896
        end
    end
end