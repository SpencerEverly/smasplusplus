local blockmanager = require("blockmanager")
local costumeblock = require("ai/costumeblock")

local blockID = BLOCK_ID

local block = {}

blockmanager.setBlockSettings({
	id = blockID,
	bumpable = true
})

costumeblock.register(blockID)

return block