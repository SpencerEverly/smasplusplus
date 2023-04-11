local Collisionz = {}

Collisionz.CollisionSpot = {
    COLLISION_NONE = 0,
    COLLISION_TOP = 1,
    COLLISION_RIGHT = 2,
    COLLISION_BOTTOM = 3,
    COLLISION_LEFT = 4,
    COLLISION_CENTER = 5,
}

function Collisionz.CheckCollision(Loc1, Loc2) --Checks a collision between two things
    return (Loc1.y + Loc1.height >= Loc2.y) and
           (Loc1.y <= Loc2.y + Loc2.height) and
           (Loc1.x <= Loc2.x + Loc2.width) and
           (Loc1.x + Loc1.width >= Loc2.x)
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

--Whats side the collision happened
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
        elseif(Loc1.X - Loc1.speedX >= Loc2.x + Loc2.width - Loc2.speedX) then
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
--[[function Collisionz.vScreenCollision(A, Loc2)
    if(A == 0)
        return true
    else
        return (-vScreenX[A] <= Loc2.x + Loc2.width) and
               (-vScreenX[A] + vScreen[A].width >= Loc2.x) and
               (-vScreenY[A] <= Loc2.y + Loc2.height) and
               (-vScreenY[A] + vScreen[A].height >= Loc2.y)
    end
end]]

return Collisionz