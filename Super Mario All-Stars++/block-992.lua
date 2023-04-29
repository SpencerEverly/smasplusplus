--Blockmanager is required for setting basic Block properties
local blockManager = require("blockManager")
local smasFunctions = require("smasFunctions")

--Create the library table
local sampleBlock = {}
--BLOCK_ID is dynamic based on the name of the library file
local blockID = BLOCK_ID

--Defines Block config for our Block. You can remove superfluous definitions.
local sampleBlockSettings = {
    id = blockID,
    --Frameloop-related
    frames = 1,
    framespeed = 8, --# frames between frame change

    floorslope = 0,
    
    passthrough = true,
    isRightSlope = true
}

--Applies blockID settings
blockManager.setBlockSettings(sampleBlockSettings)

--Register the vulnerable harm types for this Block. The first table defines the harm types the Block should be affected by, while the second maps an effect to each, if desired.

--Custom local definitions below


--Register events
function sampleBlock.onInitAPI()
    blockManager.registerEvent(blockID, sampleBlock, "onTickEndBlock")
    --registerEvent(sampleBlock, "onBlockHit")
end

function sampleBlock.checkSlopeCollision(p, v)
    local playerCameraDistanceX = p.x - camera.x
    local playerCameraDistanceY = p.y - camera.y
    local playerBlockDistanceX = p.x - v.x
    local playerBlockDistanceY = p.y - v.y
    
    local distIntoTile = p.x - (v.x * v.width)
    local percentage = distIntoTile / v.width
    local riseAtDist = (percentage * v.height)
    
    if sampleBlockSettings.isRightSlope then
        riseAtDist = 32 - riseAtDist
    end
    local collisionPointSlope = vector(p.x, ((v.y + 1) * v.height) - riseAtDist)
    
    return collisionPointSlope
end

function sampleBlock.onTickEndBlock(v)
    -- Don't run code for invisible entities
    if v.isHidden or v:mem(0x5A, FIELD_BOOL) then return end
    
    local data = v.data
    
    local startPosition = v.x + v.width
    local endPosition = v.y + v.height
    
    for _,p in ipairs(Player.get()) do
        if Collisionz.CheckCollision(p, v) then
            Text.print(sampleBlock.checkSlopeCollision(p, v).y, 100, 120)
            Text.print("Works!", 100, 100)
            p.speedY = -0.4
            p:mem(0x146, FIELD_WORD, 2)
            p:mem(0x48, FIELD_WORD, 992)
        end
    end
end

--Gotta return the library table!
return sampleBlock