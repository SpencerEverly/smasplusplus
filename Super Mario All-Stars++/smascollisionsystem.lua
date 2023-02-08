local smasCollisionSystem = {}

function smasCollisionSystem.onInitAPI()
    
end

function smasCollisionSystem.checkCollision(Loc1, Loc2)
    if (
        (Loc1.y + Loc1.height >= Loc2.y) and
        (Loc1.y <= Loc2.y + Loc2.height) and
        (Loc1.x <= Loc2.x + Loc2.width) and
        (Loc1.x + Loc1.width >= Loc2.x)
    ) then
        return true
    else
        return false
    end
end

function smasCollisionSystem.checkCollisionIntersect(Loc1, Loc2)
    if (Loc1.y < Loc2.y) then
        return false
    elseif (Loc1.y + Loc1.height > Loc2.y + Loc2.height)
        return false
    elseif(Loc1.x < Loc2.x)
        return false
    elseif(Loc1.x + Loc1.width > Loc2.x + Loc2.width)
        return false
    else
        return true
    end
end

return smasCollisionSystem