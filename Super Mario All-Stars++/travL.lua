--   __                   __      __           
--  / /__________ __   __/ /     / /_  ______ _
-- / __/ ___/ __ `/ | / / /     / / / / / __ `/
--/ /_/ /  / /_/ /| |/ / /____ / / /_/ / /_/ / 
--\__/_/   \__,_/ |___/_____(_)_/\__,_/\__,_/ 
--Version 1.1
--written by Enjl

local travL = {}
travL.settings = API.load("wandR")

--helper constants
local UP = 1
local LEFT = 2
local DOWN = 3
local RIGHT = 4

local prevX, prevY = 0, 0

local c = Camera.get()[1]

--offset for getIntersecting checks
local boxOffset = {}
boxOffset[UP] = {x=0, y=-32}
boxOffset[LEFT] = {x=-32, y=0}
boxOffset[DOWN] = {x=0, y=32}
boxOffset[RIGHT] = {x=32, y=0}

--initialise arrow sprite
local arrowSprite = Graphics.loadImage(Misc.resolveFile("travL_arrow.png") or Misc.resolveFile("travL/travL_arrow.png"))
travL.showArrows = true

local vt = {x = 16, y = 12}
local vtTable = {}
for i=1, 4 do
    vtTable[i] = {    vt.x + boxOffset[i].x - 0.5 * arrowSprite.width, vt.y + boxOffset[i].y - 0.5 * arrowSprite.height,
                    vt.x + boxOffset[i].x + 0.5 * arrowSprite.width, vt.y + boxOffset[i].y - 0.5 * arrowSprite.height,
                    vt.x + boxOffset[i].x - 0.5 * arrowSprite.width, vt.y + boxOffset[i].y + 0.5 * arrowSprite.height,
                    vt.x + boxOffset[i].x + 0.5 * arrowSprite.width, vt.y + boxOffset[i].y + 0.5 * arrowSprite.height}
end

local txTable = {}
txTable[UP] = {0,0,1,0,0,1,1,1}
txTable[LEFT] = {1,0,1,1,0,0,0,1}
txTable[DOWN] = {1,1,0,1,1,0,0,0}
txTable[RIGHT] = {0,1,0,0,1,1,1,0}

--movement related
local walkTo = {}
walkTo[UP] = function() player.upKeyPressing = true end
walkTo[LEFT] = function() player.leftKeyPressing = true end
walkTo[DOWN] = function() player.downKeyPressing = true end
walkTo[RIGHT] = function() player.rightKeyPressing = true end

local getInput = {}
getInput[UP] = function() return player.upKeyPressing end
getInput[LEFT] = function() return player.leftKeyPressing end
getInput[DOWN] = function() return player.downKeyPressing end
getInput[RIGHT] = function() return player.rightKeyPressing end

--table containing number of adjacent levels in directions ULDR
local adjacentFields = {0,0,0,0}

--arrow display delay (to prevent flickering)
local isStanding = 8

local wasWalking = false
local wasPaused = false
local prevDir = 0

--helper functions
local function isMoving()
    return world.playerIsCurrentWalking
end

local function getDirection()
    return world.playerCurrentDirection
end

local function isOnLevel()
    for k,v in pairs(Level.get()) do
        if v.x == world.playerX and v.y == world.playerY then
            return true
        end
    end
    return false
end

--inserts visible tiles into the table
local function insertTiles(idx, tableToCheck)
    for k,v in pairs(tableToCheck) do
        adjacentFields[idx] = 1
        break
    end
end

local function checkSurroundings()
    adjacentFields = {0,0,0,0}
    for i=1, 4 do
        local x = world.playerX + boxOffset[i].x
        local y = world.playerY + boxOffset[i].y
        insertTiles(i, Path.getIntersecting(x + 15, y + 15, x + 17, y + 17))
        --
        local levelList = {}
        for k,v in pairs(Level.get()) do
            if x + 16 > v.x and x + 16 < v.x + 32 and y + 16 > v.y and y + 16 < v.y + 32 then
                table.insert(levelList, v)
            end
        end
        insertTiles(i, levelList)
        --
        --insertTiles(i, Level.getIntersecting(x + 15, y + 15, x + 17, y + 17))
    end
end

--override arrow sprite
function travL.setSprite(newSprite)
    arrowSprite = newSprite
    for i=1, 4 do
        vtTable[i] = {    vt.x + boxOffset[i].x - 0.5 * arrowSprite.width, vt.y + boxOffset[i].y - 0.5 * arrowSprite.height,
                        vt.x + boxOffset[i].x + 0.5 * arrowSprite.width, vt.y + boxOffset[i].y - 0.5 * arrowSprite.height,
                        vt.x + boxOffset[i].x - 0.5 * arrowSprite.width, vt.y + boxOffset[i].y + 0.5 * arrowSprite.height,
                        vt.x + boxOffset[i].x + 0.5 * arrowSprite.width, vt.y + boxOffset[i].y + 0.5 * arrowSprite.height}
    end
end

--------------------------

function travL.onInitAPI()
    registerEvent(travL, "onTick", "onTick", false)
    registerEvent(travL, "onInputUpdate", "onInputUpdate", false)
    registerEvent(travL, "onStart", "onStart", false)
end

function travL.onInputUpdate()
    local isPaused = mem(0x00B250E2, FIELD_WORD)
    local storeMovement
    if isPaused and wasWalking then
        storeMovement = true
    end
    if wasPaused and wasWalking and not isPaused then
        walkTo[prevDir]()
    end
    
    wasWalking = storeMovement or isMoving()
    wasPaused = isPaused
end

function travL.onStart()
    local offsetX = world.playerX/32
    if (offsetX%1 ~= 0) then
        if offsetX%1 < 0.5 then
            world.playerX = math.floor(offsetX) * 32
        else
            world.playerX = math.ceil(offsetX) * 32
        end
    end
    local offsetY = world.playerY/32
    if (offsetY%1 ~= 0) then
        if offsetY%1 < 0.5 then
            world.playerY = math.floor(offsetY) * 32
        else
            world.playerY = math.ceil(offsetY) * 32
        end
    end
    checkSurroundings()
end

function travL.onTick()
    isStanding = isStanding + 1
    
    if world.playerWalkingTimer ~= 0 then
        isStanding = 0
    end
    
    if not isOnLevel() then
        if isMoving() or wasWalking then
            wasWalking = false
            local playerDir = (getDirection() + 2)%4
            if playerDir == 0 then playerDir = 4 end
            local input = getInput[playerDir]()
            
            --lock inputs to prevent cancelling
            player.upKeyPressing = false
            player.downKeyPressing = false
            player.leftKeyPressing = false
            player.rightKeyPressing = false
            
            checkSurroundings()
            
            if input then
                --however, allow turning around
                walkTo[playerDir]()
            else
                local targetDirection = 0
                local adjacentTiles = 0
                for k,v in pairs(adjacentFields) do
                    if k ~= playerDir and v == 1 then --exclude direction from where player came
                        adjacentTiles = adjacentTiles + v
                        targetDir = k
                    end
                end
                --if we find more than one adjacent tile we're at an intersection
                if adjacentTiles == 1 then
                    walkTo[targetDir]()
                    prevDir = targetDir
                end
            end
        end
    end
    --draw
    if isStanding >= 8 and travL.showArrows then
        if world.playerX ~= prevX or world.playerY ~= prevY then
            checkSurroundings()
        end
        for k,v in pairs(adjacentFields) do
            if v == 1 then
                Graphics.glDraw{vertexCoords = {world.playerX - c.x + vtTable[k][1], world.playerY - c.y + vtTable[k][2], 
                                                world.playerX - c.x + vtTable[k][3], world.playerY - c.y + vtTable[k][4], 
                                                world.playerX - c.x + vtTable[k][5], world.playerY - c.y + vtTable[k][6], 
                                                world.playerX - c.x + vtTable[k][7], world.playerY - c.y + vtTable[k][8]},
                                                textureCoords = txTable[k], texture = arrowSprite, priority = -6, 
                                                primitive = Graphics.GL_TRIANGLE_STRIP}
            end
        end
    end
    if isStanding > 0 then
        prevX = world.playerX
        prevY = world.playerY
    end
end

return travL