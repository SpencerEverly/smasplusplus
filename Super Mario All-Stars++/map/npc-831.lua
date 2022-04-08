--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


smwMap.setObjSettings(npcID,{
    framesY = 5,

    onTickObj = (function(v)
        local totalFrames = smwMap.getObjectConfig(v.id).framesY

        if v.levelDestroyed then
            v.frameY = (totalFrames - 1)
            v.graphicsOffsetX = 0
            v.graphicsOffsetY = 0
        else
            v.frameY = smwMap.doBasicAnimation(v,totalFrames - 1,4)
            v.graphicsOffsetX = -4
            v.graphicsOffsetY = -40 + math.cos(v.data.animationTimer / 32) * 4
        end
    end),

    isLevel = true,

    hasDestroyedAnimation = true,
})


return obj