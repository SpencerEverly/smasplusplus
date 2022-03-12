--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


local signID = 766

-- If true, the sign will show up even (greyed out) even if the level itself is locked.
local showBooIfLocked = true


smwMap.setObjSettings(npcID,{
    framesY = 7,

    gfxoffsetx = -16,

    onTickObj = (function(v)
        v.frameY = smwMap.doBasicAnimation(v,smwMap.getObjectConfig(v.id).framesY,6)
		
		-- Control sign
        if (v.lockedFade < 1 or (showBooIfLocked and not v.hideIfLocked)) and v.data.sign == nil then
            v.data.sign = smwMap.createObject(signID,v.x + 16,v.y - 62)
            v.data.sign.data.levelObj = v

            v.data.sign.hideIfLocked = (v.hideIfLocked or not showBooIfLocked)
        end

        if v.data.sign ~= nil then
            v.data.sign.lockedFade = v.lockedFade
        end
    end),

    isLevel = true,
})


return obj