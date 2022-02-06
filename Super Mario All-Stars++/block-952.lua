--[[

	Written by MrDoubleA
	Please give credit!

	Part of MrDoubleA's NPC Pack

]]

local blockManager = require("blockManager")

local ai = require("yiYoshi/eggBlock_ai")


local eggBlock = {}
local blockID = BLOCK_ID

local defaultContentID = (blockID + 3)


local eggBlockSettings = table.join({
	id = blockID,
	
	frames = 1,
	framespeed = 8,

	defaultContentID = defaultContentID,
},ai.sharedSettings)

blockManager.setBlockSettings(eggBlockSettings)


ai.register(blockID)

return eggBlock