--Making SMB2 blocks semisolid, for making it a solid again remove some semilsolid settings

local blockManager = require("blockManager")

local semisolidsmb2block = {}
local blockID = BLOCK_ID


local semisolidsmb2blockSettings = {
    id = blockID,
    
    width = 32,
    height = 32,
    
    frames = 1,
    framespeed = 1,

    lightradius = 96,
    lightbrightness = 0.45,
    lightoffsetx = 0,
    lightoffsety = 0,
    lightcolor = Color.white,
    semisolid = true,
    passthrough = false,
}

blockManager.setBlockSettings(semisolidsmb2blockSettings)
    
return semisolidsmb2block