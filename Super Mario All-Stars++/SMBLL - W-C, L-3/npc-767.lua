--[[

	Written by MrDoubleA
	Please give credit!

	Credit to Saturnyoshi for starting to make "newplants" and creating most of the graphics used

	Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local ai = require("piranhaPlant_ai")

local piranhaPlant = {}
local npcID = NPC_ID

local piranhaPlantSettings = {
	id = npcID,
	
	gfxwidth = 32,
	gfxheight = 48,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 48,
	
	frames = 2,
	framestyle = 1,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt = false,
	nogravity = true,
	noblockcollision = true,
	nofireball = false,
	noiceball = false,
	noyoshi = false,
	nowaterphysics = true,
	
	jumphurt = true,
	spinjumpsafe = true,
	harmlessgrab = false,
	harmlessthrown = false,


	movementSpeed = 2,    -- How fast the NPC moves when coming out or retracting back.
	hideTime      = 50,   -- How long the NPC rests before coming out.
	restTime      = 50,   -- How long the NPC rests before retracting back.
	ignorePlayers = true, -- Whether or not the NPC can come out, even if there's a player in the way.
	
	isHorizontal = false, -- Whether or not the NPC is horizontal.
}

npcManager.setNpcSettings(piranhaPlantSettings)
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_HELD,
		HARM_TYPE_TAIL,
		HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD
	}, 
	{
		[HARM_TYPE_JUMP]            = 10,
		[HARM_TYPE_FROMBELOW]       = 10,
		[HARM_TYPE_NPC]             = 10,
		[HARM_TYPE_PROJECTILE_USED] = 10,
		[HARM_TYPE_HELD]            = 10,
		[HARM_TYPE_TAIL]            = 10,
		[HARM_TYPE_SPINJUMP]        = 10,
	}
)

ai.registerPlant(npcID)

return piranhaPlant