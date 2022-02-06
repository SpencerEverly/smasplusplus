--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


local lifetime = 32


smwMap.setObjSettings(npcID,{
    framesY = 4,

    onTickObj = (function(v)
        if v.isOffScreen then
            v:remove()
            return
        end

        v.data.speedX = v.data.speedX or 0
        v.data.speedY = (v.data.speedY or 0) + 0.1

        v.x = v.x + v.data.speedX
        v.y = v.y + v.data.speedY
    end),

    priority = -10,
})


smwMap.switchBlockEffectID = npcID


return obj