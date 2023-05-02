--[[

	Written by MrDoubleA
	Please give credit!

    Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")

local ai = require("swingingPlatform_ai")


local swingingPlatform = {}
local npcID = NPC_ID


local swingingPlatformSettings = {
	id = npcID,
	
	gfxwidth = 96,
	gfxheight = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 32,
	
	frames = 1,
	framestyle = 0,
	framespeed = 8,

	npcblock = false,
	npcblocktop = true,
	playerblock = false,
	playerblocktop = true,

	nohurt = true,
	nogravity = true,
	noblockcollision = true,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = true,
	
	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = true,
	harmlessthrown = true,

	ignorethrownnpcs = true,
	staticdirection = true,
	luahandlesspeed = true,
	nogliding = true,
}

npcManager.setNpcSettings(swingingPlatformSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})


ai.registerPlatform(npcID)


return swingingPlatform