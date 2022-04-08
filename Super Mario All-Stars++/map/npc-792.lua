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
        v.frameY = smwMap.doBasicAnimation(v,smwMap.getObjectConfig(v.id).framesY,12)

        v.x = v.x - math.cos(v.data.animationTimer/32)*0.25
        v.y = v.y - 0.2

        if v.data.animationTimer >= 240 then
            v:remove()
        end
    end),

    priority = -11,
})


return obj