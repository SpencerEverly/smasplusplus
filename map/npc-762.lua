--[[

    smwMap.lua
    by MrDoubleA

    See main file for more

]]

local smwMap = require("smwMap")


local npcID = NPC_ID
local obj = {}


local splashID = 795


local riseSpeed = -6
local gravity = 0.23

local STATE_WAITING = 0
local STATE_RISING  = 1
local STATE_FALLING = 2


local function doSplash(v)
    SFX.play(72)

    if splashID == nil then return end

    smwMap.createObject(splashID, v.x, v.data.startY + v.settings.offset)
end


smwMap.setObjSettings(npcID,{
    framesY = 4,

    onTickObj = (function(v)
        v.data.speedX = v.data.speedX or 0
        v.data.speedY = v.data.speedY or 0

        v.data.startX = v.data.startX or v.x
        v.data.startY = v.data.startY or v.y

        v.data.state = v.data.state or STATE_WAITING


        v.cutoffBottomY = v.data.startY + v.settings.offset + v.height*0.5


        if smwMap.mainPlayer.lookAroundState ~= smwMap.LOOK_AROUND_STATE.INACTIVE then
            return
        end


        local startJumpHeight = (v.data.startY + v.settings.offset + v.height)


        if v.data.state == STATE_WAITING then
            if math.abs(smwMap.mainPlayer.x - v.data.startX) <= 4 and math.abs(smwMap.mainPlayer.y - v.data.startY) <= 4 then
                v.y = startJumpHeight
                v.data.speedY = riseSpeed

                v.data.state = STATE_RISING

                doSplash(v)
            else
                v.y = startJumpHeight + 64
            end
        elseif v.data.state == STATE_RISING then
            -- based on waterleaper.lua
            local peak = (v.data.startY + v.settings.offset - v.settings.jumpHeight)
            local limit = peak + ((v.data.speedY * v.data.speedY) / (2 * gravity))

            if v.y < limit then
                v.data.state = STATE_FALLING
            end
        elseif v.data.state == STATE_FALLING then
            v.data.speedY = v.data.speedY + gravity

            if v.y >= startJumpHeight then
                v.data.state = STATE_WAITING
                v.data.speedY = 0

                doSplash(v)
            end
        end

        v.y = v.y + v.data.speedY


        -- Frames
        local totalFrames = smwMap.getObjectConfig(v.id).framesY

        v.frameY = smwMap.doBasicAnimation(v,totalFrames*0.5,8)

        if v.data.speedY > 0 then
            v.frameY = v.frameY + totalFrames*0.5
        end
    end),
})


return obj