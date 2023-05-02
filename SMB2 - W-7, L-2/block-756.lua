local blockmanager = require("blockmanager")
local blockutils = require("blocks/blockutils")

local blockID = BLOCK_ID

local block = {}

local mush1 = 154
local mush2 = 155
local mush3 = 156
local mush4 = 157

blockmanager.setBlockSettings({
    id = blockID,
    frames = 3,
    playerfilter = -1,
    npcfilter = mush1 <= mush4,
    ediblebyvine = true, -- edible by mutant vine
})

return block