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

local fireID = (npcID-7)

local piranhaPlantSettings = {
	id = npcID,
	
	gfxwidth = 64,
	gfxheight = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 64,
	height = 32,
	
	frames = 4,
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


	movementSpeed = 1.5,   -- How fast the NPC moves when coming out or retracting back.
	hideTime      = 50,    -- How long the NPC rests before coming out.
	restTime      = 100,   -- How long the NPC rests before retracting back.
	ignorePlayers = false, -- Whether or not the NPC can come out, even if there's a player in the way.

	isHorizontal   = true, -- Whether or not the NPC is horizontal.
	isVenusFlyTrap = true, -- Whether or not this NPC will attempt to look at a nearby player.


	fireID         = fireID,  -- The NPC ID of the fire shot by the NPC. If nil or 0, no fire will be shot.
	fireSpurts     = 1,       -- How many "spurts" of fire the NPC will shoot before retracting.
	firePerSpurt   = 1,       -- How many fire NPCs are shot in each "spurt".
	fireSpurtDelay = 0,       -- How many frames of delay there are between each "spurt".

	fireSpeed = 0, -- The speed of each fire NPC shot by the NPC.
	fireAngle = 0, -- The angle of each fire NPC shot by the NPC. Increases with each spurt.
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