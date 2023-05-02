local blockmanager = require("blockmanager")
local cp = require("clearpipe2")

local blockID = BLOCK_ID

local block = {}

blockmanager.setBlockSettings({
    id = blockID,
    noshadows = true,
    width = 32,
    height = 32
})

-- Up, down, left, right
cp.registerPipe(blockID, "JUNC", "CROSS", {true,  true,  true,  true})

return block