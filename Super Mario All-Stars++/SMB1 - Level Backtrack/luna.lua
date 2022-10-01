local level_dependencies_normal= require("level_dependencies_normal")

function generateAreas()
    Routine.wait(0.1, true)
    if table.icontains(smastables.__smb1Levels,"SMB1 - W-3, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-197600)
    end
    if table.icontains(smastables.__smb1Levels,"SMB1 - W-4, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-196800)
    end
    if table.icontains(smastables.__smb1Levels,"SMB1 - W-5, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-196000)
    end
    if table.icontains(smastables.__smb1Levels,"SMB1 - W-6, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-195200)
    end
    if table.icontains(smastables.__smb1Levels,"SMB1 - W-7, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-194400)
    end
    if table.icontains(smastables.__smb1Levels,"SMB1 - W-8, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-193600)
    end
end

function onStart()
    Routine.run(generateAreas)
end

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 1 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 1
            SaveData.smwMap.playerX = -197440
            SaveData.smwMap.playerY = -199264
        elseif p:mem(0x15E, FIELD_WORD) == 2 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 2
            SaveData.smwMap.playerX = -196480
            SaveData.smwMap.playerY = -199264
        elseif p:mem(0x15E, FIELD_WORD) == 3 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 3
            SaveData.smwMap.playerX = -195776
            SaveData.smwMap.playerY = -199072
        elseif p:mem(0x15E, FIELD_WORD) == 4 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 4
            SaveData.smwMap.playerX = -194944
            SaveData.smwMap.playerY = -199136
        elseif p:mem(0x15E, FIELD_WORD) == 8 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 5
            SaveData.smwMap.playerX = -194112
            SaveData.smwMap.playerY = -199200
        elseif p:mem(0x15E, FIELD_WORD) == 5 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 6
            SaveData.smwMap.playerX = -193280
            SaveData.smwMap.playerY = -199104
        elseif p:mem(0x15E, FIELD_WORD) == 6 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 7
            SaveData.smwMap.playerX = -192416
            SaveData.smwMap.playerY = -199200
        elseif p:mem(0x15E, FIELD_WORD) == 7 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB1 World 8
            SaveData.smwMap.playerX = -191712
            SaveData.smwMap.playerY = -199168
        end
    end
end