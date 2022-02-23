local npcManager = require("npcManager")
local ai = require("chainChomp_ai")

local chainChomp = {}
local npcID = NPC_ID

local effectID = (npcID)

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
	framespeed = 8,

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

	maxDistance = 128,  -- Maximum distance chomp can go before being pulled back by chains.
	roamDistance = 80,  -- How far the chomp will hop before turning around.
	lungeDistance = 96, -- How close a player has to be to be lunged at.

	lungesToEscape = nil, -- How many lunges are need to escape from the pole. If this is nil, it cannot escape.
	escapeID = nil,       -- What NPC ID to change to when escaping. If this is nil, it cannot escape.
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

ai.registerChomp(npcID)

return chainChomp