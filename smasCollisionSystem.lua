local smasCollisionSystem = {}

smasCollisionSystem.enabled = true
smasCollisionSystem.semiSolidEntities = {}

function smasCollisionSystem.onInitAPI()
    registerEvent(smasCollisionSystem,"onDraw")
end

function smasCollisionSystem.registerSemiSolid(x, y, width, height, isSlope)
    if x == nil then
        error("X must be specified!")
        return
    end
    if y == nil then
        error("Y must be specified!")
        return
    end
    if width == nil then
        error("Width must be specified!")
        return
    end
    if height == nil then
        error("Height must be specified!")
        return
    end
    if isSlope == nil then
        isSlope = false
    end
    table.insert(smasCollisionSystem.semiSolidEntities, {x = x, y = y, width = width, height = height, isSlope = isSlope})
end

function smasCollisionSystem.onDraw()
    if smasCollisionSystem.enabled then
        for i = 1,#smasCollisionSystem.semiSolidEntities do
            for _,p in ipairs(Player.get()) do
                local pBottom = p.y + p.height
                if pBottom == smasCollisionSystem.semiSolidEntities[i].y then
                    
                end
            end
        end
    end
end

return smasCollisionSystem