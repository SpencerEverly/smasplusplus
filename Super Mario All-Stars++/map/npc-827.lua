--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


local booID = 761

-- If true, the boo will show up even (greyed out) even if the level itself is locked.
local showBooIfLocked = true


smwMap.setObjSettings(npcID,{
    framesY = 1,

    gfxoffsety = 6,

    onTickObj = (function(v)
        v.frameY = smwMap.doBasicAnimation(v,smwMap.getObjectConfig(v.id).framesY,4)

        -- Control boo
        if (v.lockedFade < 1 or (showBooIfLocked and not v.hideIfLocked)) and v.data.boo == nil then
            v.data.boo = smwMap.createObject(booID,v.x,v.y - 18)
            v.data.boo.data.levelObj = v

            v.data.boo.hideIfLocked = (v.hideIfLocked or not showBooIfLocked)
        end

        if v.data.boo ~= nil then
            v.data.boo.lockedFade = v.lockedFade
        end
    end),

    isLevel = true,
})


return obj