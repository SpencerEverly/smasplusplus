--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


smwMap.setObjSettings(npcID,{
    framesY = 7,

    onTickObj = (function(v)
        v.data.timer = (v.data.timer or 0) + 1

        v.frameY = math.floor(v.data.timer/4)

        local totalFrames = smwMap.getObjectConfig(v.id).framesY

        if v.data.timer >= 12 and v.data.affectingLevel ~= nil then
            v.data.affectingLevel.lockedFade = math.max(0,v.data.affectingLevel.lockedFade - 0.1)
        end

        if v.frameY >= totalFrames then
            v:remove()
        end
    end),

    priority = -10,
})


smwMap.unlockLevelEffectID = npcID


return obj