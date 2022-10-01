local level_dependencies_normal= require("level_dependencies_normal")

function generateAreas()
    Routine.wait(0.1, true)
    if table.icontains(smastables.__smb2Levels,"SMB2 - W-3, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-197600)
    end
    if table.icontains(smastables.__smb2Levels,"SMB2 - W-4, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-196800)
    end
    if table.icontains(smastables.__smb2Levels,"SMB2 - W-5, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-196000)
    end
    if table.icontains(smastables.__smb2Levels,"SMB2 - W-6, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-195200)
    end
    if table.icontains(smastables.__smb2Levels,"SMB2 - W-7, L-1.lvlx") then
        Misc.setCameraPosition(-200000,-200600,-200000,-194400)
    end
end

function onStart()
    Routine.run(generateAreas)
end

function onExit()
    for _,p in ipairs(Player.get()) do
        if p:mem(0x15E, FIELD_WORD) == 1 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 1
            SaveData.smwMap.playerX = -198688
            SaveData.smwMap.playerY = -198944
        elseif p:mem(0x15E, FIELD_WORD) == 2 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 2
            SaveData.smwMap.playerX = -198496
            SaveData.smwMap.playerY = -198880
        elseif p:mem(0x15E, FIELD_WORD) == 3 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 3
            SaveData.smwMap.playerX = -198688
            SaveData.smwMap.playerY = -198752
        elseif p:mem(0x15E, FIELD_WORD) == 4 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 4
            SaveData.smwMap.playerX = -198496
            SaveData.smwMap.playerY = -198688
        elseif p:mem(0x15E, FIELD_WORD) == 7 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 5
            SaveData.smwMap.playerX = -198688
            SaveData.smwMap.playerY = -198560
        elseif p:mem(0x15E, FIELD_WORD) == 5 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 6
            SaveData.smwMap.playerX = -198496
            SaveData.smwMap.playerY = -198496
        elseif p:mem(0x15E, FIELD_WORD) == 6 and p.forcedState == FORCEDSTATE_INVISIBLE then --SMB2 World 7
            SaveData.smwMap.playerX = -198688
            SaveData.smwMap.playerY = -198368
        end
    end
end