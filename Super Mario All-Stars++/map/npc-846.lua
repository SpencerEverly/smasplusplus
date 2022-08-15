--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


smwMap.setObjSettings(npcID,{
    framesY = 1,

    onTickObj = (function(v)
        v.frameY = smwMap.doBasicAnimation(v,smwMap.getObjectConfig(v.id).framesY,6)
    end),

    isLevel = true,
})


return obj