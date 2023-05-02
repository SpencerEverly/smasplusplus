--Blockmanager is required for setting basic Block properties
local blockManager = require("blockManager")

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

    semisolid = false, --top-only collision

    floorslope = -1
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

--function sampleBlock.onTickEndBlock(v)
    -- Don't run code for invisible entities
--    if v.isHidden or v:mem(0x5A, FIELD_BOOL) then return end
    
--    local data = v.data
--end

--Gotta return the library table!
return sampleBlock