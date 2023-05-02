--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


local spinDirections = {0,2,1,3}

local useSound = Misc.resolveSoundFile("smwMap/starWarp")


smwMap.setObjSettings(npcID,{
    framesY = 6,

    onTickObj = (function(v)
        v.frameY = smwMap.doBasicAnimation(v,smwMap.getObjectConfig(v.id).framesY,6)
    end),

    doWarpOverride = (function(p,v)
        if p.timer == 0 and p.isMainPlayer then
            SFX.play(useSound)
        end

        local raiseSpeed = (p.timer - 40) * 0.17

        if raiseSpeed > 0 then
            p.zOffset = p.zOffset - raiseSpeed
        end


        p.timer = p.timer + 1

        p.animationTimer = 0

        p.timer2 = p.timer2 + math.min(1, p.timer/60)*0.5
        p.direction = spinDirections[(math.floor(p.timer2) % #spinDirections) + 1]

        return (p.timer > 128)
    end),

    isLevel = true,
    isWarp = true,
})


return obj