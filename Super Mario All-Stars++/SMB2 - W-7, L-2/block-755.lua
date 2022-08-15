local blockmanager = require("blockmanager")

local block = {}

local blockID = BLOCK_ID

--disable vanilla collision
blockmanager.setBlockSettings({
    id = blockID,
    frames = 3,
    framespeed = 8,
    playerfilter = -1,
    npcfilter = 206,
})


return block