local Collisionz = {}

local smasGlobals = require("smasGlobals")

Collisionz.CollisionSpot = {
    COLLISION_NONE = 0,
    COLLISION_TOP = 1,
    COLLISION_RIGHT = 2,
    COLLISION_BOTTOM = 3,
    COLLISION_LEFT = 4,
    COLLISION_CENTER = 5,
    COLLISION_SLOPEUPLEFT = 6,
    COLLISION_SLOPEUPRIGHT = 7,
    COLLISION_SLOPEDOWNLEFT = 8,
    COLLISION_SLOPEDOWNRIGHT = 9,
}

function Collisionz.CheckCollision(Loc1, Loc2) --Checks a collision between two things
    return (Loc1.y + Loc1.height >= Loc2.y) and
           (Loc1.y <= Loc2.y + Loc2.height) and
           (Loc1.x <= Loc2.x + Loc2.width) and
           (Loc1.x + Loc1.width >= Loc2.x)
end

function Collisionz.CheckCollisionBlock(Loc1, Loc2) --Checks a collision between two things
    return (Loc1.y + Loc1.height - 0.2 >= Loc2.y) and
           (Loc1.y <= Loc2.y + Loc2.height + 0.2) and
           (Loc1.x <= Loc2.x + Loc2.width + 0.2) and
           (Loc1.x + Loc1.width - 0.2 >= Loc2.x)
end

function Collisionz.CheckCollisionNoEntity(x1, y1, width1, height1, x2, y2, width2, height2) --Checks a collision between two things
    return (y1 + height1 >= y2) and
           (y1 <= y2 + height2) and
           (x1 <= x2 + width2) and
           (x1 + width1 >= x2)
end

function Collisionz.CheckCollisionIntersect(Loc1, Loc2) --Checks a collision intersection
    if(Loc1.y < Loc2.y) then
        return false
    end

    if(Loc1.y + Loc1.height > Loc2.y + Loc2.height) then
        return false
    end

    if(Loc1.x < Loc2.x) then
        return false
    end

    if(Loc1.x + Loc1.width > Loc2.x + Loc2.width) then
        return false
    end

    return true
end

function Collisionz.CheckIntersect(x1, y1, width1, height1, x2, y2, width2, height2) --Checks a collision intersection, without any entity involved
    if(y1 < y2) then
        return false
    end

    if(y1 + height1 > y2 + height2) then
        return false
    end

    if(x1 < x2) then
        return false
    end

    if(x1 + width1 > x2 + width2) then
        return false
    end

    return true
end

function Collisionz.n00bCollision(Loc1, Loc2) --"Makes the game easier for the people who whine about the detection being 'off'" -redigit(?)
    local tempn00bCollision = false
    local EZ = 2

    if(Loc2.width >= 32 - EZ * 2 and Loc2.height >= 32 - EZ * 2) then
        if(Loc1.y + Loc1.height - EZ >= Loc2.y) then
            if(Loc1.y + EZ <= Loc2.y + Loc2.height) then
                if(Loc1.x + EZ <= (Loc2.x + Loc2.width)) then
                    if(Loc1.x + Loc1.width - EZ >= Loc2.X) then
                        tempn00bCollision = true;
                    end
                end
            end
        end
    else
        if(Loc1.y + Loc1.height >= Loc2.y) then
            if(Loc1.y <= Loc2.y + Loc2.height) then
                if(Loc1.x <= Loc2.x + Loc2.width) then
                    if(Loc1.x + Loc1.width >= Loc2.x) then
                        tempn00bCollision = true;
                    end
                end
            end
        end
    end

    return tempn00bCollision
end

--What side the collision happened
function Collisionz.FindCollision(Loc1, Loc2)
    local tempFindCollision = Collisionz.CollisionSpot.COLLISION_NONE

    if(Loc1.y + Loc1.height - Loc1.speedY <= Loc2.y - Loc2.speedY) then
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_TOP
    elseif(Loc1.x - Loc1.speedX >= Loc2.x + Loc2.width - Loc2.speedX) then
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_RIGHT
    elseif(Loc1.x + Loc1.width - Loc1.speedX <= Loc2.x - Loc2.speedX) then
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_LEFT
    elseif(Loc1.y - Loc1.speedY > Loc2.y + Loc2.height - Loc2.speedY - 0.1) then
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_BOTTOM
    else
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_CENTER
    end

    return tempFindCollision
end

--What side the collision happened, without any entities involved
function Collisionz.FindCollisionNoEntities(x1, y1, width1, height1, speedX1, speedY1, x2, y2, width2, height2, speedX2, speedY2)
    local tempFindCollision = Collisionz.CollisionSpot.COLLISION_NONE

    if(y1 + height1 - speedY1 <= y2 - speedY2) then
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_TOP
    elseif(x1 - speedX1 >= x2 + width2 - speedX2) then
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_RIGHT
    elseif(x1 + width1 - speedX1 <= x2 - speedX2) then
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_LEFT
    elseif(y1 - speedY1 > y2 + height2 - speedY2 - 0.1) then
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_BOTTOM
    else
        tempFindCollision = Collisionz.CollisionSpot.COLLISION_CENTER
    end

    return tempFindCollision
end

--Used when a NPC is activated to see if it should spawn
function Collisionz.NPCStartCollision(Loc1, Loc2)
    local tempNPCStartCollision = false
    if(Loc1.x < Loc2.x + Loc2.width) then
        if(Loc1.x + Loc1.width > Loc2.x) then
            if(Loc1.y < Loc2.y + Loc2.height) then
                if(Loc1.y + Loc1.height > Loc2.y) then
                    tempNPCStartCollision = true
                end
            end
        end
    end
    return tempNPCStartCollision
end

--Easy mode collision for jumping on NPCs
function Collisionz.EasyModeCollision(Loc1, Loc2, StandOn)
    local tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_NONE
    
    if StandOn == nil then
        error("Must specify if this is being standed on or not.")
        return
    end

    if(not Defines.levelFreeze) then --Defines.levelFreeze = FreezeNPCs
        if(Loc1.y + Loc1.height - Loc1.speedY <= Loc2.y - Loc2.speedY + 10) then
            if(Loc1.speedY > Loc2.speedY or StandOn) then
                tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_TOP
            else
                tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_NONE
            end
        elseif(Loc1.x - Loc1.speedX >= Loc2.x + Loc2.width - Loc2.speedX) then
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_RIGHT
        elseif(Loc1.x + Loc1.width - Loc1.speedX <= Loc2.x - Loc2.speedX) then
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_LEFT
        elseif(Loc1.y - Loc1.speedY >= Loc2.y + Loc2.height - Loc2.speedY) then
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_BOTTOM
        else
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_CENTER
        end
    else
        if(Loc1.y + Loc1.height - Loc1.speedY <= Loc2.y + 10) then
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_TOP
        elseif(Loc1.x - Loc1.speedX >= Loc2.x + Loc2.width) then
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_RIGHT
        elseif(Loc1.x + Loc1.width - Loc1.speedX <= Loc2.x) then
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_LEFT
        elseif(Loc1.y - Loc1.speedY >= Loc2.y + Loc2.height) then
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_BOTTOM
        else
            tempEasyModeCollision = Collisionz.CollisionSpot.COLLISION_CENTER
        end
    end

    return tempEasyModeCollision
end

function Collisionz.getPlayerStandingBlocks(p)
    local blockStandings = {}
    local blockCollidingIDs = {}
    for k,v in ipairs(Block.get()) do
        table.insert(blockStandings, Collisionz.FindCollision(p, v))
    end
    for i = 0,#blockStandings do
        if blockStandings[i] == 1 then
            table.insert(blockCollidingIDs, Block(i).id)
        end
    end
    return blockCollidingIDs
end

--Easy mode collision for jumping on NPCs while on yoshi/boot
function Collisionz.BootCollision(Loc1, Loc2, StandOn)
    local tempBootCollision = Collisionz.CollisionSpot.COLLISION_NONE

    if(not Defines.levelFreeze) then --Defines.levelFreeze = FreezeNPCs
        if(Loc1.y + Loc1.height - Loc1.speedY <= Loc2.y - Loc2.speedY + 16) then
            if(Loc1.speedY > Loc2.speedY or StandOn) then
                tempBootCollision = Collisionz.CollisionSpot.COLLISION_TOP
            else
                tempBootCollision = Collisionz.CollisionSpot.COLLISION_NONE
            end
        elseif(Loc1.x - Loc1.speedX >= Loc2.x + Loc2.width - Loc2.speedX) then
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_RIGHT
        elseif(Loc1.x + Loc1.width - Loc1.speedX <= Loc2.x - Loc2.speedX) then
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_LEFT
        elseif(Loc1.y - Loc1.speedY >= Loc2.y + Loc2.height - Loc2.speedY) then
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_BOTTOM
        else
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_CENTER
        end
    else
        if(Loc1.y + Loc1.height - Loc1.speedY <= Loc2.y + 16) then
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_TOP
        elseif(Loc1.x - Loc1.speedX >= Loc2.x + Loc2.width) then
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_RIGHT
        elseif(Loc1.x + Loc1.width - Loc1.speedX <= Loc2.x) then
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_LEFT
        elseif(Loc1.y - Loc1.speedY >= Loc2.y + Loc2.height) then
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_BOTTOM
        else
            tempBootCollision = Collisionz.CollisionSpot.COLLISION_CENTER
        end
    end

    return tempBootCollision
end

function Collisionz.CursorCollision(Loc1, Loc2)
    return (Loc1.x <= Loc2.x + Loc2.width - 1) and
           (Loc1.x + Loc1.width >= Loc2.x + 1) and
           (Loc1.y <= Loc2.y + Loc2.Height - 1) and
           (Loc1.y + Loc1.Height >= Loc2.y + 1)
end

--Shakey block collision
function Collisionz.ShakeCollision(Loc1, Loc2, ShakeY3)
    local tempShakeCollision = false

    if(Loc1.x + 1 <= Loc2.x + Loc2.width) then
        if(Loc1.x + Loc1.width - 1 >= Loc2.x) then
            if(Loc1.y <= Loc2.y + Loc2.height + ShakeY3) then
                if(Loc1.y + Loc1.height >= Loc2.y + ShakeY3) then
                    tempShakeCollision = true
                end
            end
        end
    end

    return tempShakeCollision
end

--vScreen collisions
function Collisionz.ScreenCollision(A, Loc2)
    if(A == 0) then
        return true
    else
        return (-camera.x <= Loc2.x + Loc2.width) and
               (-camera.x + camera.width >= Loc2.x) and
               (-camera.y <= Loc2.y + Loc2.height) and
               (-camera.y + camera.height >= Loc2.y)
    end
end

--vScreen collisions 2
function Collisionz.ScreenCollision2(A, Loc2)
    return (-camera.x + 64 <= Loc2.X + Loc2.width) and
           (-camera.x + camera.width - 64 >= Loc2.x) and
           (-camera.y + 96 <= Loc2.Y + Loc2.height) and
           (-camera.y + camera.height - 64 >= Loc2.y)
end

--Collision detection for blocks. Prevents walking on walls.
function Collisionz.WalkingCollision(Loc1, Loc2)
    local tempWalkingCollision = false;

    if(Loc1.x <= Loc2.x + Loc2.width + Loc1.speedX) then
        if(Loc1.x + Loc1.width >= Loc2.x + Loc1.speedX) then
            tempWalkingCollision = true
        end
    end

    return tempWalkingCollision
end

--Collision detection for blocks. Lets NPCs fall through cracks.
function Collisionz.WalkingCollision2(Loc1, Loc2)
    local tempWalkingCollision2 = false

    if (Loc1.x <= Loc2.x + Loc2.width - Loc1.speedX - 1) then
        if (Loc1.x + Loc1.width >= Loc2.x - Loc1.speedX + 1) then
            tempWalkingCollision2 = true
        end
    end

    return tempWalkingCollision2
end

--Factors in beltspeed
function Collisionz.WalkingCollision3(Loc1, Loc2, BeltSpeed)
    local tempWalkingCollision3 = false;

    if (Loc1.x <= Loc2.x + Loc2.width - (Loc1.speedX + BeltSpeed) - 1) then
        if(Loc1.x + Loc1.width >= Loc2.x - (Loc1.speedX + BeltSpeed) + 1) then
            tempWalkingCollision3 = true;
        end
    end

    return tempWalkingCollision3
end

--Helps the player to walk over 1 unit cracks
function Collisionz.FindRunningCollision(Loc1, Loc2)
    local tempFindRunningCollision = Collisionz.CollisionSpot.COLLISION_NONE;

    if(Loc1.y + Loc1.height - Loc1.speedY - 2.5 <= Loc2.y - Loc2.speedY) then
        tempFindRunningCollision = Collisionz.CollisionSpot.COLLISION_TOP
    elseif(Loc1.x - Loc1.speedX >= Loc2.x + Loc2.width - Loc2.speedX) then
        tempFindRunningCollision = Collisionz.CollisionSpot.COLLISION_RIGHT
    elseif(Loc1.x + Loc1.width - Loc1.speedX <= Loc2.x - Loc2.speedX) then
        tempFindRunningCollision = Collisionz.CollisionSpot.COLLISION_LEFT
    elseif(Loc1.y - Loc1.speedY >= Loc2.y + Loc2.height - Loc2.speedY) then
        tempFindRunningCollision = Collisionz.CollisionSpot.COLLISION_BOTTOM
    else
        tempFindRunningCollision = Collisionz.CollisionSpot.COLLISION_CENTER
    end

    return tempFindRunningCollision
end

--Determines if an NPC should turnaround
function Collisionz.ShouldTurnAround(Loc1, Loc2, Direction)
    local tempShouldTurnAround = true

    if(Loc1.y + Loc1.height + 8 <= Loc2.y + Loc2.height) then
        if(Loc1.y + Loc1.height + 8 >= Loc2.y) then
            if(Loc1.x + Loc1.width * 0.5 + (8 * Direction) <= Loc2.x + Loc2.width) then
                if(Loc1.x + Loc1.width * 0.5 + (8 * Direction) >= Loc2.x) then
                    if(Loc2.y > Loc1.y + Loc1.height - 8) then
                        tempShouldTurnAround = false
                    end
                end
            end
        end
    end

    return tempShouldTurnAround
end

--Determines if an NPC can come out of a pipe
function Collisionz.CanComeOut(Loc1, Loc2)
    local tempCanComeOut = true

    if (Loc1.x <= Loc2.x + Loc2.width + 32) then
        if (Loc1.x + Loc1.width >= Loc2.x - 32) then
            if (Loc1.y <= Loc2.y + Loc2.height + 300) then
                if (Loc1.y + Loc1.height >= Loc2.y - 300) then
                    tempCanComeOut = false
                end
            end
        end
    end

    return tempCanComeOut
end

function Collisionz.IsPlayerCloseToShell(Loc1, Loc2, closeCounter)
    return (Loc1.x <= Loc2.x + closeCounter) and
        (Loc1.x + Loc1.width >= Loc2.x + Loc2.width - closeCounter)
end

--Determines if a shell can move or not
function Collisionz.CanMoveShell(Loc1, Loc2)
    local tempCanMoveShell = true

    if (Loc1.x >= Loc2.x + Loc2.width + 8) then
        if (Loc1.x + Loc1.width <= Loc2.x - 8) then
            if (Loc1.y <= Loc2.y + Loc2.height + 300) then
                if (Loc1.y + Loc1.height >= Loc2.y - 300) then
                    tempCanMoveShell = false
                end
            end
        end
    end

    return tempCanMoveShell
end

--Fixes NPCs sinking through the ground
function Collisionz.CheckHitSpot1(Loc1, Loc2)
    local tempCheckHitSpot1 = false

    if (Loc1.y + Loc1.height - Loc1.speedY - mem(0x00B2C874, FIELD_FLOAT) <= Loc2.y - Loc2.speedY) then --The memory address is the NPC gravity
        tempCheckHitSpot1 = true;
    end

    return tempCheckHitSpot1
end

function Collisionz.blockGetTopYTouching(block, loc)
    --Get slope type
    local blockType = Block.config[block.id].floorslope;
    local slopeDirection

    if((blockType >= 1) and (blockType <= maxBlockType)) then
        slopeDirection = blockType
    else
        slopeDirection = 0
    end

    --The simple case, no slope
    if(slopeDirection == 0) then
        return block.y
    end

    --The degenerate case, no width
    if(block.width <= 0) then
        return block.y
    end

    --The following uses a slope calculation like 1.3 does

    --Get right or left x coordinate as relevant for the slope direction
    local refX = loc.x;
    if(slopeDirection > 0) then
        refX = refX + loc.width
    end

    --Get how far along the slope we are in the x direction
    local slope = (refX - block.x) / block.width
    if(slopeDirection > 0) then
        slope = 1 - slope
    end
    if(slope < 0) then
        slope = 0
    end
    if(slope > 1) then
        slope = 1
    end

    --Determine the y coordinate
    return block.y + block.height - (block.height * slope);
end

return Collisionz