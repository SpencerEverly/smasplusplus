local smasPlayerPhysicsSystem = {}

if smasGlobals == nil then
    smasGlobals = require("smasGlobals")
end

local playerManager = require("playerManager")

function smasPlayerPhysicsSystem.onInitAPI()
    registerEvent(smasPlayerPhysicsSystem,"onTick")
    registerEvent(smasPlayerPhysicsSystem,"onDraw")
end

function smasPlayerPhysicsSystem.getBlockSlopeType(block)
    local slopeTypes = {}
    for i = 1,#Block.SLOPE_LR_FLOOR do
        if Block.SLOPE_LR_FLOOR[i] == block) then
            return 1
        end
    end
    for i = 1,#Block.SLOPE_RL_FLOOR do
        if Block.SLOPE_RL_FLOOR[i] == block) then
            return -1
        end
    end
    for i = 1,#Block.SLOPE_LR_CEIL do
        if Block.SLOPE_LR_CEIL[i] == block) then
            return 1
        end
    end
    for i = 1,#Block.SLOPE_RL_CEIL do
        if Block.SLOPE_RL_CEIL[i] == block) then
            return -1
        end
    end
    if slopeTypes == {} then
        return 0
    end
end

function UpdatePlayer()
    local B = 0
    local C = 0
    local D = 0
    local speedVar = 0 --The percentage of the player's speed
    local tempSpeed = 0
    local HitSpot = 0
    local tempBlockHit = {}
    local tempBlockHit[3] = {0}
    local tempHit = false
    local tempSpring = false
    local tempShell = false
    local tempHit2 = false
    local tempHit3 = 0
    local tempHitSpeed = 0
    local oldSpeedY = 0
    local oldStandingOnNpc = 0
    local tempLocation
    local tempLocation3
    local spinKill = false
    local oldSlope = 0
    local A1 = 0
    local B1 = 0
    local C1 = 0
    local X = 0
    local Y = 0
    local tempBool = false
    local blankNPC = 0
    local MessageNPC = 0
    local PlrMid = 0
    local Slope = 0
    local tempSlope = 0
    local tempSlope2 = 0
    local tempSlope2X = 0
    local tempSlope3 = 0
    local movingBlock = false
    local blockPushX = 0
    local oldLoc
    local DontResetGrabTime = false
    local SlippySpeedX = 0
    local wasSlippy = false
    local Angle = 0 --The angle of the player
    local slideSpeed = 0 --The speed of the sliding
    
    
    --StealBonus() --allows a dead player to come back to life by using a 1-up
    --ClownCar() --updates players in the clown car
    
    for i = 1,numPlayers do
        
        
        
        speedVar = 1
        if Playur[i].slopeBlockIndex > 0 then --The slope stood on
            if Playur[i].speedX > 0 and smasPlayerPhysicsSystem.getBlockSlopeType(Block(Playur[i].slopeBlockIndex)) == -1 or Playur[i].speedX < 0 and smasPlayerPhysicsSystem.getBlockSlopeType(Block(Playur[i].slopeBlockIndex)) == 1 then
                speedVar = (1 - Block(Playur[i].slopeBlockIndex).height / Block(Playur[i].slopeBlockIndex).width * 0.5)
            elseif not Playur[i].sliding then
                speedVar = (1 + Block(Playur[i].slopeBlockIndex).height / Block(Playur[i].slopeBlockIndex).width * 0.5) * 0.5
            end
        end
        if Playur[i].stoned then --Is stoned?
            speedVar = 1 --Reset to normal
        end
        if playerManager.getBaseID(Playur[i].character) == 3 then --If any character is based on Peach...
            speedVar = (speedVar * 0.93)
        end
        if playerManager.getBaseID(Playur[i].character) == 4 then --If any character is based on Toad...
            speedVar = (speedVar * 1.07)
        end
        if Playur[i].underwater then --Is player underwater?
            if(Playur[i].speedY == 0 or Playur[i].slopeBlockIndex > 0 or Playur[i].standingNPCIndex ~= 0) then --If speedY is 0, the slope index is greater than 0, and standing on an NPC...
                speedVar = (speedVar * 0.25) --Walking = slow
            else
                speedVar = (speedVar * 0.5) --Swimming = a little faster
            end
        end
        
        if Playur[i].sliding then --Is sliding?
            if Playur[i].slopeBlockIndex > 0 then --The slope stood on
                Angle = 1 / Block(Playur[i].slopeBlockIndex).width / Block(Playur[i].slopeBlockIndex).height
                slideSpeed = 0.1 * Angle * smasPlayerPhysicsSystem.getBlockSlopeType(Block(Playur[i].slopeBlockIndex)
                if (slideSpeed > 0 and Playur[i].speedX < 0) then
                    Playur[i].speedX = Playur[i].speedX + slideSpeed * 2
                elseif (slideSpeed < 0 and Playur[i].speedX > 0) then
                    Playur[i].speedX = Playur[i].speedX + slideSpeed * 2
                else
                    Playur[i].speedX = Playur[i].speedX + slideSpeed
                end
            elseif Playur[i].speedY == 0 or Playur[i].standingNPCIndex ~= 0 then
                if Playur[i].speedX > 0.2 then
                    Playur[i].speedX = Playur[i].speedX - 0.1
                elseif Playur[i].speedX < -0.2 then
                    Playur[i].speedX = Playur[i].speedX + 0.1
                else
                    Playur[i].speedX = 0
                    Playur[i].sliding = false
                end
            end
        end
        
    end
end

function smasPlayerPhysicsSystem.onDraw()
    UpdatePlayer()
end

return smasPlayerPhysicsSystem