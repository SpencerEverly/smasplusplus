local blockmanager = require("blockmanager")
local cp = require("blocks/ai/clearpipe")

local blockID = BLOCK_ID

local block = {}

blockmanager.setBlockSettings({
    id = blockID,
    noshadows = true,
    width = 64,
    height = 32
})

-- Up, down, left, right
cp.registerPipe(blockID, "END", "VERT", {true,  true,  false, false})

return block