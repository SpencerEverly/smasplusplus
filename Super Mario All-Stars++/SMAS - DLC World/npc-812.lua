--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


smwMap.setObjSettings(npcID,{
    framesY = 2,

    onTickObj = (function(v)
        local totalFrames = smwMap.getObjectConfig(v.id).framesY

        if v.levelDestroyed then
            v.frameY = (totalFrames - 1)
        else
            v.frameY = smwMap.doBasicAnimation(v,totalFrames - 1,8)
        end
    end),

    isLevel = true,

    hasDestroyedAnimation = true,
})


return obj