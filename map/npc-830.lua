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
        if v.isOffScreen then
            return
        end

        local totalFrames = smwMap.getObjectConfig(v.id).framesY

        v.frameY = smwMap.doBasicAnimation(v,totalFrames*0.5,6)


        -- Is there a path close to this that's unlocked? If so, show unlocked frame
        for _,pathObj in ipairs(smwMap.pathsList) do
            if smwMap.pathIsUnlocked(pathObj.name) and pathObj.unlockingEventObj == nil then
                local position = vector(v.x,v.y)
                local startPoint = pathObj.splineObj:evaluate(0):tov2()
                local endPoint   = pathObj.splineObj:evaluate(1):tov2()

                if (position - startPoint).length <= 16 or (position - endPoint).length <= 16 then
                    v.frameY = v.frameY + totalFrames*0.5
                    break
                end
            end
        end

        v.lockedFade = 0
    end),

    isWarp = true,
})


return obj