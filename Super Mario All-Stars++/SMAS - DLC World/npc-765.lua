--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


smwMap.setObjSettings(npcID,{
    framesY = 6,

    gfxoffsety = -8,

    usePositionBasedPriority = true,

    onTickObj = (function(v)
        -- Frames
        local totalFrames = smwMap.getObjectConfig(v.id).framesY

        if v.data.state ~= smwMap.ENCOUNTER_STATE.SLEEPING then
            v.frameY = smwMap.doBasicAnimation(v,(totalFrames*0.5) - 1,16 / v.data.animationSpeed)
        else
            v.frameY = (totalFrames*0.5) - 1
        end

        if v.data.direction == DIR_RIGHT then
            v.frameY = v.frameY + totalFrames*0.5
        end
    end),

    isEncounter = true,
})


return obj