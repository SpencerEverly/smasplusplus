--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


local smokeID = 792

-- If true, the smoke will show up even (greyed out) even if the level itself is locked.
local showSmokeIfLocked = false


smwMap.setObjSettings(npcID,{
    framesY = 1,

    gfxoffsety = 6,

    onTickObj = (function(v)
        v.frameY = smwMap.doBasicAnimation(v,smwMap.getObjectConfig(v.id).framesY,4)

        -- Spawn chimney smoke
        if not v.isOffScreen and (v.lockedFade == 0 or (showSmokeIfLocked and not v.hideIfLocked)) and v.data.animationTimer%80 == 1 then
            local smoke = smwMap.createObject(smokeID,v.x + v.width*0.5 - 4, v.y - v.height*0.5 - 16)

            smoke.lockedFade = v.lockedFade
            smoke.hideIfLocked = v.hideIfLocked
        end
    end),

    isLevel = true,
})


return obj