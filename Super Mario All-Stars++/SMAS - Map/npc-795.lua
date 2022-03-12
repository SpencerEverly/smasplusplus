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
        v.data.timer = (v.data.timer or 0) + 1

        local totalFrames = smwMap.getObjectConfig(v.id).framesY
        local age = (v.data.timer / lifetime)

        v.frameY = math.min(totalFrames-1,math.floor(age * totalFrames))

        if age >= 1 then
            v:remove()
        end
    end),
})


return obj