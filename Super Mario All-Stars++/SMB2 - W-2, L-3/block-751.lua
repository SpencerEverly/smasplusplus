--[[

	Written by MrDoubleA
	Please give credit!

	Part of MrDoubleA's NPC Pack

]]

local blockManager = require("blockManager")
local ai = require("oneWayWall_ai")

local oneWayWall = {}
local blockID = BLOCK_ID


local oneWayWallSettings = {
    id = blockID,
    
    width = 64,
    height = 64,
	
	frames = 5,
	framespeed = 8,

	lightradius = 96,
	lightbrightness = 0.45,
	lightoffsetx = 0,
	lightoffsety = 0,
    lightcolor = Color.white,
    
    semisolid = true,
    passthrough = false,

	direction = ai.DIRECTION_UP, -- The direction that the block faces.
	
	interactSFX = SFX.open(Misc.resolveFile("oneWayWall_interact.wav")), -- The sound effect played when interacting with the block. Can be nil for none, a number for a vanilla sound, or a sound effect object/string for a custom sound.
	shakeOnInteraction = true,                                           -- Whether or not the block will shake when interacting with an object.
}

blockManager.setBlockSettings(oneWayWallSettings)

ai.register(blockID)

return oneWayWall