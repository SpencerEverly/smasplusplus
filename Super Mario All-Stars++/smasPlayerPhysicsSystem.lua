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

smasPlayerPhysicsSystem.speedVar = 0 --The percentage of the player's speed
smasPlayerPhysicsSystem.slideSpeed = 0 --The speed of the sliding
smasPlayerPhysicsSystem.Angle = 0 --The angle of the player(?)

function UpdatePlayer()
    for i = 1,numPlayers do
        smasPlayerPhysicsSystem.speedVar = 1
        if Playur[i].slopeBlockIndex > 0 then --The slope stood on
            if Playur[i].speedX > 0 and smasPlayerPhysicsSystem.getBlockSlopeType(Block(Playur[i].slopeBlockIndex)) == -1 or Playur[i].speedX < 0 and smasPlayerPhysicsSystem.getBlockSlopeType(Block(Playur[i].slopeBlockIndex)) == 1 then
                smasPlayerPhysicsSystem.speedVar = (1 - Block(Playur[i].slopeBlockIndex).height / Block(Playur[i].slopeBlockIndex).width * 0.5)
            elseif not Playur[i].sliding then
                smasPlayerPhysicsSystem.speedVar = (1 + Block(Playur[i].slopeBlockIndex).height / Block(Playur[i].slopeBlockIndex).width * 0.5) * 0.5
            end
        end
        if Playur[i].stoned then --Is stoned?
            smasPlayerPhysicsSystem.speedVar = 1 --Reset to normal
        end
        if playerManager.getBaseID(Playur[i].character) == 3 then --If any character is based on Peach...
            smasPlayerPhysicsSystem.speedVar = (smasPlayerPhysicsSystem.speedVar * 0.93)
        end
        if playerManager.getBaseID(Playur[i].character) == 4 then --If any character is based on Toad...
            smasPlayerPhysicsSystem.speedVar = (smasPlayerPhysicsSystem.speedVar * 1.07)
        end
        if Playur[i].underwater then --Is player underwater?
            if(Playur[i].speedY == 0 or Playur[i].slopeBlockIndex > 0 or Playur[i].standingNPCIndex ~= 0) then --If speedY is 0, the slope index is greater than 0, and standing on an NPC...
                smasPlayerPhysicsSystem.speedVar = (smasPlayerPhysicsSystem.speedVar * 0.25) --Walking = slow
            else
                smasPlayerPhysicsSystem.speedVar = (smasPlayerPhysicsSystem.speedVar * 0.5) --Swimming = a little faster
            end
        end
        
        if Playur[i].sliding then --Is sliding?
            if Playur[i].slopeBlockIndex > 0 then --The slope stood on
                smasPlayerPhysicsSystem.Angle = 1 / Block(Playur[i].slopeBlockIndex).width / Block(Playur[i].slopeBlockIndex).height
                smasPlayerPhysicsSystem.slideSpeed = 0.1 * Angle * smasPlayerPhysicsSystem.getBlockSlopeType(Block(Playur[i].slopeBlockIndex)
                if (smasPlayerPhysicsSystem.slideSpeed > 0 and Playur[i].speedX < 0) then
                    Playur[i].speedX = Playur[i].speedX + smasPlayerPhysicsSystem.slideSpeed * 2
                elseif (smasPlayerPhysicsSystem.slideSpeed < 0 and Playur[i].speedX > 0) then
                    Playur[i].speedX = Playur[i].speedX + smasPlayerPhysicsSystem.slideSpeed * 2
                else
                    Playur[i].speedX = Playur[i].speedX + smasPlayerPhysicsSystem.slideSpeed
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