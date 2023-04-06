local Misk = {}

local rng = require("base/rng")
local smasverbosemode = require("smasverbosemode")
local customCamera = require("customCamera")
local smastables = require("smastables")

local GM_STAR_ADDR = mem(0x00B25714, FIELD_DWORD)
local GM_CREDITS = mem(0x00B25948, FIELD_DWORD)

function Misk.onInitAPI()
    registerEvent(Misk,"onStart")
    registerEvent(Misk,"onDraw")
    registerEvent(Misk,"onCameraDraw")
end

function Misc.worldFilename() --Gets the world filename. Thanks KBM_Quine!
    local episodeFiles = Misc.listFiles(Misc.episodePath())
    local worldFile
    for _,v in ipairs(episodeFiles) do
        if string.match(v, ".*%.wld") then
            worldFile = string.match(v, ".*%.wld")
        end
    end
    return worldFile
end

function Misc.inSuperMarioAllStarsPlusPlus() --Checks and sees if SMAS++ is being run. If not, some functions won't run. Idk if this is a reliable check but oh well, I tried.
    return (Misc.worldFilename() == "__World Map.wld" --Checks to see if the world map is this...
        and io.exists(Misc.episodePath().."SMB1 - W-1, L-1.lvlx") --Then checks the first levels of each mandatory game (+ SMBLL).
        and io.exists(Misc.episodePath().."SMBLL - W-1, L-1.lvlx")
        and io.exists(Misc.episodePath().."SMB2 - W-1, L-1.lvlx")
        and io.exists(Misc.episodePath().."SMB3 - W-1, L-1.lvlx")
        and io.exists(Misc.episodePath().."SMW - W-1, L-YI1.lvlx")
        and io.exists(Misc.episodePath().."SMBS - W-1, L-1.lvlx")
    )
end

if Misc.inSuperMarioAllStarsPlusPlus() then
    function Misc.listUserFiles(path)
        if path == nil then
            return Misc.listFiles(Misc.episodePath().."___MainUserDirectory/")
        else
            return Misc.listFiles(Misc.episodePath().."___MainUserDirectory/"..path)
        end
    end

    function Misc.toggleVerboseMode() --This, when activated, will spit out a verbose list of things you have done/executed. Toggle again to turn off.
        if smasverbosemode.activated then
            smasverbosemode.activated = false
        elseif not smasverbosemode.activated then
            smasverbosemode.activated = true
        end
    end
    
    function Misc.unlockAnyBrokenPaths() --WIP function that will unlock any path if any star has been collected prior.
        if Level.filename() == "map.lvlx" and smwMap then
            --**Super Mario Bros. 1**
            --World 1
            if table.icontains(SaveData.completeLevels,"SMB1 - W-1, L-1.lvlx") then
                smwMap.unlockPath("toSMB11-1")
                smwMap.unlockPath("toSMB11-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-1, L-2.lvlx") then
                smwMap.unlockPath("toSMB11-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-1, L-3.lvlx") then
                smwMap.unlockPath("toSMB11-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-1, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-2")
                smwMap.unlockPath("toSMB1W-1FromW2")
            end
            --World 2
            if table.icontains(SaveData.completeLevels,"SMB1 - W-2, L-1.lvlx") then
                smwMap.unlockPath("toSMB1W-2Path1")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-2, L-2.lvlx") then
                smwMap.unlockPath("toSMB12-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-2, L-3.lvlx") then
                smwMap.unlockPath("toSMB12-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-2, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-2Path3")
                smwMap.unlockPath("toSMB13-1")
            end
            --World 3
            if table.icontains(SaveData.completeLevels,"SMB1 - W-3, L-1.lvlx") then
                smwMap.unlockPath("toSMB13-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-3, L-2.lvlx") then
                smwMap.unlockPath("toSMB13-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-3, L-3.lvlx") then
                smwMap.unlockPath("toSMB13-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-3, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-3Path2")
                smwMap.unlockPath("toSMB14-1")
            end
            --World 4
            if table.icontains(SaveData.completeLevels,"SMB1 - W-4, L-1.lvlx") then
                smwMap.unlockPath("toSMB14-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-4, L-2.lvlx") then
                smwMap.unlockPath("toSMB14-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-4, L-3.lvlx") then
                smwMap.unlockPath("toSMB14-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-4, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-4Path1")
                smwMap.unlockPath("toSMB15-1")
            end
            --World 5
            if table.icontains(SaveData.completeLevels,"SMB1 - W-5, L-1.lvlx") then
                smwMap.unlockPath("toSMB15-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-5, L-2.lvlx") then
                smwMap.unlockPath("toSMB15-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-5, L-3.lvlx") then
                smwMap.unlockPath("toSMB15-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-5, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-5Path1")
                smwMap.unlockPath("toSMB16-1")
            end
            --World 6
            if table.icontains(SaveData.completeLevels,"SMB1 - W-6, L-1.lvlx") then
                smwMap.unlockPath("toSMB16-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-6, L-2.lvlx") then
                smwMap.unlockPath("toSMB16-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-6, L-3.lvlx") then
                smwMap.unlockPath("toSMB16-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-6, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-6Path1")
                smwMap.unlockPath("toSMB17-1")
            end
            --World 7
            if table.icontains(SaveData.completeLevels,"SMB1 - W-7, L-1.lvlx") then
                smwMap.unlockPath("toSMB17-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-7, L-2.lvlx") then
                smwMap.unlockPath("toSMB17-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-7, L-3.lvlx") then
                smwMap.unlockPath("toSMB17-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-7, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-7Path1")
                smwMap.unlockPath("toSMB18-1")
            end
            --World 8
            if table.icontains(SaveData.completeLevels,"SMB1 - W-8, L-1.lvlx") then
                smwMap.unlockPath("toSMB18-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-8, L-2.lvlx") then
                smwMap.unlockPath("toSMB18-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-8, L-3.lvlx") then
                smwMap.unlockPath("toSMB18-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-8, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-8Path1")
                smwMap.unlockPath("toSMB19-1")
            end
            --World 9
            if table.icontains(SaveData.completeLevels,"SMB1 - W-9, L-1.lvlx") then
                smwMap.unlockPath("toSMB19-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-9, L-2.lvlx") then
                smwMap.unlockPath("toSMB19-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-9, L-3.lvlx") then
                smwMap.unlockPath("toSMB19-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB1 - W-9, L-4.lvlx") then
                smwMap.unlockPath("toSMB1W-9Path1")
                smwMap.unlockPath("toSMB1W-9Path2")
                smwMap.unlockPath("toSMB1W-9Path3")
            end
            
            --**Super Mario Bros. 2**
            --World 1
            if table.icontains(SaveData.completeLevels,"SMB2 - W-1, L-1.lvlx") then
                smwMap.unlockPath("toSMB21-1")
                smwMap.unlockPath("toSMB21-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-1, L-2.lvlx") then
                smwMap.unlockPath("toSMB21-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-1, L-3.lvlx") then
                smwMap.unlockPath("toSMB22-1")
            end
            --World 2
            if table.icontains(SaveData.completeLevels,"SMB2 - W-2, L-1.lvlx") then
                smwMap.unlockPath("toSMB22-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-2, L-2.lvlx") then
                smwMap.unlockPath("toSMB22-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-2, L-3.lvlx") then
                smwMap.unlockPath("toSMB23-1")
            end
            --World 3
            if table.icontains(SaveData.completeLevels,"SMB2 - W-3, L-1.lvlx") then
                smwMap.unlockPath("toSMB23-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-3, L-2.lvlx") then
                smwMap.unlockPath("toSMB23-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-3, L-3.lvlx") then
                smwMap.unlockPath("toSMB24-1")
            end
            --World 4
            if table.icontains(SaveData.completeLevels,"SMB2 - W-4, L-1.lvlx") then
                smwMap.unlockPath("toSMB24-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-4, L-2.lvlx") then
                smwMap.unlockPath("toSMB24-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-4, L-3.lvlx") then
                smwMap.unlockPath("toSMB25-1")
            end
            --World 5
            if table.icontains(SaveData.completeLevels,"SMB2 - W-5, L-1.lvlx") then
                smwMap.unlockPath("toSMB25-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-5, L-2.lvlx") then
                smwMap.unlockPath("toSMB25-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-5, L-3.lvlx") then
                smwMap.unlockPath("toSMB26-1")
            end
            --World 6
            if table.icontains(SaveData.completeLevels,"SMB2 - W-6, L-1.lvlx") then
                smwMap.unlockPath("toSMB26-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-6, L-2.lvlx") then
                smwMap.unlockPath("toSMB26-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-6, L-3.lvlx") then
                smwMap.unlockPath("toSMB27-1")
            end
            --World 7
            if table.icontains(SaveData.completeLevels,"SMB2 - W-7, L-1.lvlx") then
                smwMap.unlockPath("toSMB27-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - W-7, L-2.lvlx") then
                smwMap.unlockPath("toSMB2Ending1")
            end
            if table.icontains(SaveData.completeLevels,"SMB2 - Ending.lvlx") then
                smwMap.unlockPath("toSMB2End")
            end
            
            --**Super Mario Bros. 3**
            --World 1
            if table.icontains(SaveData.completeLevels,"SMB3 - W-1, L-1.lvlx") then
                smwMap.unlockPath("toSMB31-1")
                smwMap.unlockPath("toSMB31-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-1, L-2.lvlx") then
                smwMap.unlockPath("toSMB21-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-1, L-3.lvlx") then
                smwMap.unlockPath("toSMB31-Toad1Path1")
                smwMap.unlockPath("toSMB31-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-1, L-4.lvlx") then
                smwMap.unlockPath("toSMB31-Bonus1")
                smwMap.unlockPath("toSMB31-Fortress1")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-1, L-Fortress.lvlx") then
                smwMap.unlockPath("toSMB31-5")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-1, L-5.lvlx") then
                smwMap.unlockPath("toSMB31-6")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-1, L-6.lvlx") then
                smwMap.unlockPath("toSMB31-Castle")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-1, L-Airship.lvlx") then
                smwMap.unlockPath("toSMB3W-2Warp1")
                smwMap.unlockPath("toSMB32-1")
            end
            --World 2
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-1.lvlx") then
                smwMap.unlockPath("toSMB32-Bonus1")
                smwMap.unlockPath("toSMB32-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-2.lvlx") then
                smwMap.unlockPath("toSMB32-Fortress1")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-Fortress.lvlx") then
                smwMap.unlockPath("toSMB32-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-3.lvlx") then
                smwMap.unlockPath("toSMB32-Quicksand")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-Quicksand.lvlx") then
                smwMap.unlockPath("toSMB32-4")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-4.lvlx") then
                smwMap.unlockPath("toSMB32-5")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-5.lvlx") then
                smwMap.unlockPath("toSMB32-Pyramid")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-Pyramid.lvlx") then
                smwMap.unlockPath("toSMB32-Castle")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-2, L-Airship.lvlx") then
                smwMap.unlockPath("toSMB3W-2Path1")
                smwMap.unlockPath("toSMB33-1")
            end
            --World 3
            if table.icontains(SaveData.completeLevels,"SMB3 - W-3, L-1.lvlx") then
                smwMap.unlockPath("toSMB33-2")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-3, L-2.lvlx") then
                smwMap.unlockPath("toSMB3W-3Path1")
                smwMap.unlockPath("toSMB33-ToadHouse1")
                smwMap.unlockPath("toSMB33-3")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-3, L-3.lvlx") then
                smwMap.unlockPath("toSMB33-Fortress1")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-3, L-Fortress1.lvlx") then
                smwMap.unlockPath("toSMB3W-3Path4")
                smwMap.unlockPath("toSMB33-4")
                smwMap.unlockPath("toSMB33-5")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-3, L-4.lvlx") then
                smwMap.unlockPath("toSMB33-6")
            end
            if table.icontains(SaveData.completeLevels,"SMB3 - W-3, L-5.lvlx") then
                smwMap.unlockPath("toSMB33-Boat1")
            end
            --*TBD*
            
            --**Super Mario Bros. Lost Levels**
            --World 1
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-1, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL1-1")
                smwMap.unlockPath("toSMBLL1-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-1, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL1-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-1, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL1-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-1, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-1Path1")
                smwMap.unlockPath("toSMBLL2-1")
            end
            --World 2
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-2, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL2-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-2, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL2-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-2, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL2-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-2, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-2Path1")
                smwMap.unlockPath("toSMBLL3-1")
            end
            --World 3
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-3, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL3-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-3, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL3-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-3, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL3-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-3, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-3Path1")
                smwMap.unlockPath("toSMBLL4-1")
            end
            --World 4
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-4, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL4-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-4, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL4-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-4, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL4-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-4, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-4Path1")
                smwMap.unlockPath("toSMBLL5-1")
            end
            --World 5
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-5, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL5-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-5, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL5-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-5, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL5-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-5, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-5Path1")
                smwMap.unlockPath("toSMBLL6-1")
            end
            --World 6
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-6, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL6-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-6, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL6-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-6, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL6-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-6, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-6Path1")
                smwMap.unlockPath("toSMBLL7-1")
            end
            --World 7
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-7, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL7-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-7, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL7-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-7, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL7-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-7, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-7Path1")
                smwMap.unlockPath("toSMBLL8-1")
            end
            --World 8
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-8, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL8-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-8, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL8-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-8, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL8-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-8, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-8Path1")
                smwMap.unlockPath("toSMBLL9-1")
            end
            --World 9
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-9, L-1.lvlx") then
                smwMap.unlockPath("toSMBLL9-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-9, L-2.lvlx") then
                smwMap.unlockPath("toSMBLL9-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-9, L-3.lvlx") then
                smwMap.unlockPath("toSMBLL9-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-9, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-9Path1")
                smwMap.unlockPath("toSMBLLW-9Path2")
                smwMap.unlockPath("toSMBLLW-9Path3")
            end
            --World A
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-A, L-1.lvlx") then
                smwMap.unlockPath("toSMBLLW-9Path2")
                smwMap.unlockPath("toSMBLLA-1")
                smwMap.unlockPath("toSMBLLA-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-A, L-2.lvlx") then
                smwMap.unlockPath("toSMBLLA-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-A, L-3.lvlx") then
                smwMap.unlockPath("toSMBLLA-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-A, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLB-1")
            end
            --World B
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-B, L-1.lvlx") then
                smwMap.unlockPath("toSMBLLB-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-B, L-2.lvlx") then
                smwMap.unlockPath("toSMBLLB-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-B, L-3.lvlx") then
                smwMap.unlockPath("toSMBLLB-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-B, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLC-1")
            end
            --World C
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-C, L-1.lvlx") then
                smwMap.unlockPath("toSMBLLC-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-C, L-2.lvlx") then
                smwMap.unlockPath("toSMBLLC-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-C, L-3.lvlx") then
                smwMap.unlockPath("toSMBLLC-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-C, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLD-1")
            end
            --World D
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-D, L-1.lvlx") then
                smwMap.unlockPath("toSMBLLD-2")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-D, L-2.lvlx") then
                smwMap.unlockPath("toSMBLLD-3")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-D, L-3.lvlx") then
                smwMap.unlockPath("toSMBLLD-4")
            end
            if table.icontains(SaveData.completeLevelsOptional,"SMBLL - W-D, L-4.lvlx") then
                smwMap.unlockPath("toSMBLLW-ADPath2")
            end
            
            --**Super Mario World**
            --Yoshi's Island
            if table.icontains(SaveData.completeLevels,"SMW - W-1, L-YI1.lvlx") then
                smwMap.unlockPath("toSMWYellowSwitchYI")
                smwMap.unlockPath("toSMWBeginningPipe")
            end
            if table.icontains(SaveData.completeLevels,"SMW - W-1, L-YI2.lvlx") then
                smwMap.unlockPath("toSMWYoshisIsland3")
                smwMap.unlockPath("toSMWBeginningPipe")
            end
            if table.icontains(SaveData.completeLevels,"SMW - W-1, L-YI3.lvlx") then
                smwMap.unlockPath("toSMWYoshisIsland4")
            end
            if table.icontains(SaveData.completeLevels,"SMW - W-1, L-YI4.lvlx") then
                smwMap.unlockPath("toSMWYoshisIslandCastle")
            end
            if table.icontains(SaveData.completeLevels,"SMW - W-1, L-YIIC.lvlx") then
                smwMap.unlockPath("toSMWDonutPlainsYI")
                smwMap.unlockPath("toSMWDonutPlainsMain")
            end
            --Donut Plains
            if table.icontains(SaveData.completeLevels,"SMW - W-1, L-DP1.lvlx") then
                smwMap.unlockPath("toSMWDonutPlains2")
            end
            if table.icontains(SaveData.completeLevels,"SMW - W-1, L-DP2.lvlx") then
                smwMap.unlockPath("toSMWDonutGhostHouse")
            end
            
            if table.icontains(SaveData.completeLevels,"SMW - W-2, L-DS1.lvlx") then
                smwMap.unlockPath("toSMWDonutGhostHouseSecret")
            end
            --TBD
            
            --**Super Mario Bros. Spencer**
            --World 1
            if table.icontains(SaveData.completeLevels,"SMBS - W-1, L-1.lvlx") then
                smwMap.unlockPath("toSMBS1-1")
                smwMap.unlockPath("toSMBS1-2")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-1, L-2.lvlx") then
                smwMap.unlockPath("toSMBS1-3")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-1, L-3.lvlx") then
                smwMap.unlockPath("toSMBS1-Tower")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-1, L-Tower.lvlx") then
                smwMap.unlockPath("toSMBS1-4")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-1, L-4.lvlx") then
                smwMap.unlockPath("toSMBS1-5")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-1, L-5.lvlx") then
                smwMap.unlockPath("toSMBS1-6")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-1, L-6.lvlx") then
                smwMap.unlockPath("toSMBS1-Castle")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-1, L-Castle.lvlx") then
                smwMap.unlockPath("toSMBSW-1Path3")
                smwMap.unlockPath("toSMBS2-1")
            end
            --World 2
            if table.icontains(SaveData.completeLevels,"SMBS - W-2, L-1.lvlx") then
                smwMap.unlockPath("toSMBS2-2")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-2, L-2.lvlx") then
                smwMap.unlockPath("toSMBS2-3")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-2, L-3.lvlx") then
                smwMap.unlockPath("toSMBS2-Tower1")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-2, L-Tower.lvlx") then
                smwMap.unlockPath("toSMBS2-4")
            end
            if table.icontains(SaveData.completeLevels,"SMBS - W-2, L-4.lvlx") then
                --smwMap.unlockPath("toSMBS2-5")
            end
            --TBD
            console:println("Unlocked any map paths that were completed prior.")
        else
            console:println("Unlocking map paths require you to be on the map.")
            return
        end
    end
end

function Misc.toggleWindowOnly() --This, when fullscreen, will only toggle a window instead of being in fullscreen. Toggle again to turn off.
    if mem(0x00B250D8, FIELD_BOOL) then
        console:println("Window-only mode disabled.")
        return mem(0x00B250D8, FIELD_BOOL, false)
    elseif not mem(0x00B250D8, FIELD_BOOL) then
        console:println("Window-only mode enabled.")
        return mem(0x00B250D8, FIELD_BOOL, true)
    end
end

function Misc.rngTrueValue()
    return rng.randomInt(1,10)
end

function Misc.checkCameraTransitionStatus() --Checks to see if the legacy camera transition is on.
    if mem(0x00B2B9E4, FIELD_BOOL) then
        return true
    elseif not mem(0x00B2B9E4, FIELD_BOOL) then
        return false
    end
end

function Misc.checkTargetStatus() --Returns the current targets from the camera.
    return customCamera.targets
end

function Misc.saveSaveSlot(slot)
    if slot < 0 then
        error("You can't save to a save slot less than 0.")
        return
    end
    if slot > 32767 then
        error("You can't save to a save slot greater than 32767.")
        return
    end
    if slot == nil then
        error("You must specify a save slot.")
        return
    end
    Misc.saveSlot(slot)
    Misc.saveGame()
end

function Misc.moveSaveSlot(slot, destination)
    if slot == nil then
        error("You must specify a moving save slot.")
        return
    end
    if destination == nil then
        error("You must specify a target save slot.")
        return
    end
    if destination < 0 then
        error("You can't move to a save slot that's less than 0.")
        return
    elseif destination == 0 then
        Misc.warn("You can't move to an editor save file. Please try moving to another save slot.")
        return
    elseif destination > 32767 then
        error("You can't move to a save slot that's greater than 32767.")
        return
    end
    console:println("Beginning save moving...")
    local filename = "save"..slot.."-ext.dat"
    local filenamesav = "save"..slot..".sav"
    local filename2 = "save"..destination.."-ext.dat"
    local filename2sav = "save"..destination..".sav"
    console:println("Opening all save files...")
    local f = io.open(Misc.episodePath()..filename, "a+")
    local f2 = io.open(Misc.episodePath()..filename2, "w")
    local f3 = io.open(Misc.episodePath()..filenamesav, "a+")
    local f4 = io.open(Misc.episodePath()..filename2sav, "w")
    if f then
        f:read("*all")
        if f2 then
            f2:write("*all")
            f2:close()
        end
    end
    if f3 then
        f3:read("*all")
        if f4 then
            f4:write("*all")
            f4:close()
        end
    end
    console:println("Switching save slot to new slot...")
    Misc.saveSlot(destination)
    Misc.eraseSaveSlot(slot)
    Misc.saveGame()
    console:println("Save moved.")
end

function Misc.eraseMainSaveSlot(slot) --This only erases the main save in the save slot.
    if slot < 0 then
        error("You can't erase a save slot that's less than 0.")
        return
    end
    if slot > 32767 then
        error("You can't erase a save slot greater than 32767.")
        return
    end
    local f = io.open(Misc.episodePath().."save"..slot..".sav","w")
    if f == nil then
        return
    end
    
    console:println("Erasing .sav data...")
    
    f:write('64\n3\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n#FALSE#\n"next"\n"next"\n"next"\n"next"\n0\n')
    f:close()
    
    console:println("Erased .sav data.")
end

function Misc.eraseSaveSlot(slot) --This erases all the save data in a specific slot.
    if slot < 0 then
        error("You can't erase a save slot that's less than 0.")
        return
    end
    if slot > 32767 then
        error("You can't erase a save slot that's greater than 32767.")
        return
    end
    local f = io.open(Misc.episodePath().."save"..slot..".sav","w")
    if f == nil then
        return
    end

    console:println("Erasing all save data...")

    f:write('64\n3\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n0\n0\n0\n1\n0\n#FALSE#\n"next"\n"next"\n"next"\n"next"\n0\n')
    f:close()
    
    local f2 = io.open(Misc.episodePath().."save"..slot.."-ext.dat","w")
    if f2 == nil then
        return
    end

    f2:write('{ \r--[1]-- \r{ \r   ["__costumes"]={2}, \r   ["__launcher"]={3}, \r   ["_basegame"]={4} \r}, \r--[2]-- \r{ \r \r}, \r--[3]-- \r{ \r \r}, \r--[4]-- \r{ \r   ["bigSwitch"]={5}, \r   ["_characterdata"]={6}, \r   ["starcoin"]={7}, \r   ["hud"]={8}, \r   ["starcoinCounter"]=0 \r}, \r--[5]-- \r{ \r \r}, \r--[6]-- \r{ \r   ["8"]={9}, \r   ["10"]={10}, \r   ["9"]={11}, \r   ["6"]={12}, \r   ["16"]={13}, \r   ["11"]={14}, \r   ["12"]={15}, \r   ["7"]={16}, \r   ["15"]={17}, \r   ["13"]={18}, \r   ["14"]={19} \r}, \r--[7]-- \r{ \r \r}, \r--[8]-- \r{ \r   ["score"]=0 \r}, \r--[9]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[10]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[11]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[12]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[13]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[14]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[15]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[16]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[17]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[18]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[19]-- \r{ \r   ["reservePowerup"]=0, \r   ["0x10A"]=0, \r   ["powerup"]=1, \r   ["0x16"]=1, \r   ["0x108"]=0 \r}, \r--[20]-- \r{ \r   ["maxID"]=0, \r   ["alive"]={21} \r}, \r--[21]-- \r{ \r \r} \r}')
    f2:close()
    
    console:println("Erased all save data.")
end

function Misc.getLegacyStarsCollected() --This is for the Demo 3 save migration tool which runs when stars were collected from Demo 2 and below. This will be scrapped by the time Demo 4 releases (And/or the full release happens).
    local t = {}
    for i=1, mem(0x00B251E0, FIELD_WORD) do
        t[i] = {filename = mem(GM_STAR_ADDR+(i - 1)*0x08+0x00, FIELD_STRING), index = mem(GM_STAR_ADDR+(i - 1)*0x08+0x04, FIELD_WORD)}
    end
    return t
end

function Misc.getLegacyStarsCollectedNameOnly() --This is for the Demo 3 save migration tool which runs when stars were collected from Demo 2 and below. This will be scrapped by the time Demo 4 releases (And/or the full release happens).
    local t = {}
    for i=1, mem(0x00B251E0, FIELD_WORD) do
        t[i] = mem(GM_STAR_ADDR+(i - 1)*0x08+0x00, FIELD_STRING)
    end
    return t
end

function Misc.overrideLibrary(inlib, outlib) --Unfinished override library code. Was gonna be used for... something, but I forgot. Still being kept here until it gets used somewhere.
    local loadedTable = package.loaded
    
    clearEvents(inlib)
    
    loadedTable[inlib] = outlib
    loadedTable[string.lower(inlib)] = outlib
    loadedTable[string.lower("scripts/"..inlib..".lua")] = outlib
    
    inlib = outlib
    
    return outlib
end

function Misc.use13Editor(bool)
    if Misc.inEditor() then
        if bool == nil then
            return
        end
        if bool == true then
            mem(0x00B253C4, FIELD_BOOL, true)
            console:println("Legacy 1.3 Editor enabled. Opening shortly...")
            for _,p in ipairs(Player.get()) do
                p:kill()
            end
        else
            console:println("Legacy 1.3 Editor disabled.")
            mem(0x00B253C4, FIELD_BOOL, false)
        end
    end
end

local shaketally = 0
local centeraftershake = false
local oldx = 0
local oldy = 0

function Misc.shakeWindow(shakenumber)
    if SMBX_VERSION ~= VER_SEE_MOD then
        Misc.warn("You are using the original LunaLua, and not the SEE Mod for this command. Please retrieve the SEE Mod by downloading it over at this website: https://github.com/SpencerEverly/smbx2-seemod")
        console:println("NOT USING SEE MOD! Shake window command has stopped.")
        return
    else
        if Misc.isFullscreen() then
            console:println("IN FULLSCREEN! Shake window command has stopped.")
            return
        else
            oldx = Misc.getWindowXPosition()
            oldy = Misc.getWindowYPosition()
            
            shaketally = shakenumber
            
            console:println("Shake window command has executed with a shake tally of "..tostring(shakenumber)..".")
        end
    end
end

function Misc.testModeSetSettings(player, powerup, mountType, mountColor, playerCount, showFPS, godMode, entranceIndex, player2, powerup2, mountType2, mountColor2)
    if SMBX_VERSION ~= VER_SEE_MOD then
        Misc.warn("You are using the original LunaLua, and not the SEE Mod for this command. Please retrieve the SEE Mod by downloading it over at this website: https://github.com/SpencerEverly/smbx2-seemod")
        console:println("NOT USING SEE MOD! Test mode setting changer has stopped.")
        return
    else
        if Misc.inEditor() then
            if player == nil then
                player = 1
            end
            if powerup == nil then
                powerup = 2
            end
            if mountType == nil then
                mountType = 0
            end
            if mountColor == nil then
                mountColor = 0
            end
            if player2 == nil then
                player2 = 2
            end
            if powerup2 == nil then
                powerup2 = 2
            end
            if mountType2 == nil then
                mountType2 = 0
            end
            if mountColor2 == nil then
                mountColor2 = 0
            end
            if playerCount == nil then
                playerCount = 1
            end
            if showFPS == nil then
                showFPS = false
            end
            if godMode == nil then
                godMode = false
            end
            if entranceIndex == nil then
                entranceIndex = 0
            end
            local settings = LunaDLL.LunaLuaGetTestModeSettings()
            
            settings.players[1].identity = player
            settings.players[1].powerup = powerup
            settings.players[1].mountType = mountType
            settings.players[1].mountColor = mountColor
            settings.players[2].identity = player2
            settings.players[2].powerup = powerup2
            settings.players[2].mountType = mountType2
            settings.players[2].mountColor = mountColor2
            settings.playerCount = playerCount
            settings.showFPS = showFPS
            settings.godMode = godMode
            settings.entranceIndex = entranceIndex
            
            LunaDLL.LunaLuaSetTestModeSettings(settings)
            
            console:println("Test mode setting changer completed successfully.")
        else
            Misc.warn("You're not on the editor to execute this command!")
            console:println("NOT ON THE EDITOR! Test mode setting changer has stopped executing.")
            return
        end
    end
end

function Misc.getLegacyCreditString(index)
    return readmem(GM_CREDITS+index*0x34+0x30, FIELD_STRING)
end

function Misc.setLegacyCreditString(index, string)
    writemem(GM_CREDITS+index*0x34+0x30, FIELD_STRING, string)
end

function Misc.getActualLevelName()
    local headerData = FileFormats.openLevelHeader(Level.filename())
    local levelName = headerData.levelName
    return levelName
end

function Misc.dialogSimple(stringd)
    return Text.windowDebugSimple(tostring(stringd))
end

local screenShakeTally = -1

function Misc.doPOW(shakeNumber, supressSound, letCoinsFall, eventName) --Redoing doPOW to extend the POW system. shakeNumber is how much to shake the screen, supressSound is for to play the default thwomp sound or not, letCoinsFall is if you want coins to fall or not when executed, and eventName is for if you want to specify a custom name for the POW you're executing on code. eventName is very useful, as that you can use onPOW/onPostPOW for executing certain things when executing a POW.
    
    if shakeNumber == nil then
        shakeNumber = 20 --Default screen shake value, according to the source code
    end
    if supressSound == nil then
        supressSound = false --To suppress the sound, make sure you set it as true
    end
    if letCoinsFall == nil then
        letCoinsFall = true --If false, the coins won't fall from the air.
    end
    if eventName == nil then
        eventName = "Default"
    end
    
    local eventObj = {cancelled = false}
    
    EventManager.callEvent("onPOW",eventObj,shakeNumber,supressSound,letCoinsFall,eventName)
    
    if not eventObj.cancelled then
        if not supressSound then
            Sound.playSFX(37)
        end
        
        if letCoinsFall then
            for k,v in ipairs(NPC.get(smastables.allCoinNPCIDs)) do
                if (v.isValid and not v.isHidden and NPC.isOnScreen(v)) then
                    v.ai1 = 1
                    v.speedX = RNG.random() * 1 - 0.5
                end
            end
        end
        
        screenShakeTally = shakeNumber
        
        EventManager.callEvent("onPostPOW",shakeNumber,supressSound,letCoinsFall,eventName)
    end
end

function Misc.doEarthquake(shakeNumber, eventName) --This is a replacement of Defines.earthquake. This is also similar to doPOW, except this one only has a shake number and the eventName option.
    if shakeNumber == nil then
        shakeNumber = 20 --Default screen shake value
    end
    if eventName == nil then
        eventName = "Default"
    end
    
    local eventObj = {cancelled = false}
    
    EventManager.callEvent("onEarthquake",eventObj,shakeNumber,eventName)
    
    if not eventObj.cancelled then
        screenShakeTally = shakeNumber
        
        EventManager.callEvent("onPostEarthquake",shakeNumber,eventName)
    end
end

function Misk.onDraw()
    if SMBX_VERSION == VER_SEE_MOD then
        if shaketally > 0 then
            shaketally = shaketally - 1
            Misc.setWindowPosition(((oldx + math.random(((shaketally / 4 + 4))) - math.random((shaketally / 4) + 4))),((oldy + math.random(((shaketally / 4) + 4))) - math.random(((shaketally / 4) + 4)))) --Thanks Toby Fox!
        end
    end
end

function Misk.onCameraDraw()
    if screenShakeTally > -1 then
        screenShakeTally = screenShakeTally - 1
        if screenShakeTally > 0 then
            customCamera.defaultScreenOffsetX = ((0 + math.random(((screenShakeTally / 32 + 32))) - math.random((screenShakeTally / 32) + 32)))
            customCamera.defaultScreenOffsetY = ((0 + math.random(((screenShakeTally / 32) + 32))) - math.random(((screenShakeTally / 32) + 32)))
        end
    end
    if screenShakeTally == 0 then
        customCamera.defaultScreenOffsetX = 0
        customCamera.defaultScreenOffsetY = 0
    end
end

return Misk