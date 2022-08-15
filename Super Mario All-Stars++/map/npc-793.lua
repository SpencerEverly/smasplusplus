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
    framesX = 4,
    framesY = 4,

    onTickObj = (function(v)
        v.data.timer = (v.data.timer or 0) + 1
        v.data.direction = (v.data.direction or vector.zero2)

        local totalFrames = smwMap.getObjectConfig(v.id).framesY
        local age = (v.data.timer / lifetime)

        v.frameY = math.min(totalFrames-1,math.floor(age * totalFrames))

        local speed = v.data.direction * (1-age)*2

        v.x = v.x + speed.x
        v.y = v.y + speed.y

        if age >= 1 then
            v:remove()
        end
    end),
})


smwMap.levelDestroyedSmokeEffectID = npcID


return obj