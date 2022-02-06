--[[

	Written by MrDoubleA
	Please give credit!

    Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")

local ai = require("swingingPlatform_ai")


local swingingPlatform = {}
local npcID = NPC_ID

local defaultPlatformID = (npcID + 1)


local swingingPlatformSettings = {
	id = npcID,
	
	gfxwidth = 32,
	gfxheight = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 32,
	
	frames = 1,
	framestyle = 0,
	framespeed = 8,

	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,

	nohurt = true,
	nogravity = true,
	noblockcollision = true,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = true,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = true,
	harmlessthrown = true,

	ignorethrownnpcs = true,
	staticdirection = true,
	luahandlesspeed = true,

	
	defaultPlatformID = defaultPlatformID,

	rotationBehaviour = ai.BEHAVIOUR_AUTO,
}

npcManager.setNpcSettings(swingingPlatformSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})


ai.registerController(npcID)


return swingingPlatform