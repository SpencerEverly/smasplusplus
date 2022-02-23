local npcManager = require("npcManager")
local ai = require("chainChomp_ai")

local chainChomp = {}
local npcID = NPC_ID

local effectID = (npcID-1)

local chainChompSettings = {
	id = npcID,
	
	gfxwidth = 32,
	gfxheight = 32,
	gfxoffsetx = 0,
	gfxoffsety = 2,
	width = 32,
	height = 32,
	
	frames = 2,
	framestyle = 1,
	framespeed = 4,

	speed = 1,

	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,

	nohurt=false,
	nogravity = false,
	noblockcollision = false,
	nofireball = true,
	noiceball = true,
	noyoshi= false,
	nowaterphysics = false,
	
	jumphurt = true,
	spinjumpsafe = true,
	harmlessgrab = false,
	harmlessthrown = false,

	chains = 4,
	chainWidth = 16,
	chainHeight = 16,
	
	jumpHeight = 6.5,
}

npcManager.setNpcSettings(chainChompSettings)
npcManager.registerDefines(npcID,{NPC.HITTABLE})
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
		HARM_TYPE_OFFSCREEN,
	}, 
	{
		[HARM_TYPE_FROMBELOW]=effectID,
		[HARM_TYPE_NPC]=effectID,
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]=effectID,
	}
)

ai.registerLoose(npcID)

return chainChomp