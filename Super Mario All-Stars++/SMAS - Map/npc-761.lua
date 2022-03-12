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
        v.data.animationTimer = (v.data.animationTimer or 0)

        local speedX = math.cos(v.data.animationTimer/34)*1.1
        local speedY = math.cos(v.data.animationTimer/10)*0.3

        v.x = v.x + speedX
        v.y = v.y + speedY


        -- Frames
        local totalFrames = smwMap.getObjectConfig(v.id).framesY

        v.frameY = smwMap.doBasicAnimation(v,totalFrames*0.5,12)

        if speedX > 0 then
            v.frameY = v.frameY + totalFrames*0.5
        end


        -- Priority
        v.priority = (v.data.levelObj == nil and -12) or (speedX > 0 and -56) or -49
    end),
})


return obj