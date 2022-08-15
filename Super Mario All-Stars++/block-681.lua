local blockmanager = require("blockmanager")
local costumeblock = require("ai_smas/costumeblock")

local blockID = BLOCK_ID

local block = {}

blockmanager.setBlockSettings({
    id = blockID,
    bumpable = true
})

costumeblock.register(blockID)

return block