--[[

	See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local yoshi = require("yiYoshi/yiYoshi")

local ai = require("yiYoshi/egg_ai")


local egg = {}
local npcID = NPC_ID


local smokeEffectID = npcID-1


local eggSettings = {
	id = npcID,
	
	width = 32,
	height = 32,


	nohurt = true,
	nogravity = true,
	noblockcollision = false,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = false,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	ignorethrownnpcs = true,


	speed = 16,
	luahandlesspeed = true,

	maxBounces = 3,

	smokeEffectID = smokeEffectID,
}

npcManager.setNpcSettings(eggSettings)
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_OFFSCREEN,
	},
	{
		[HARM_TYPE_JUMP]            = 10,
		[HARM_TYPE_FROMBELOW]       = 10,
		[HARM_TYPE_NPC]             = 10,
		[HARM_TYPE_PROJECTILE_USED] = 10,
		[HARM_TYPE_LAVA]            = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]            = 10,
		[HARM_TYPE_TAIL]            = 10,
		[HARM_TYPE_SPINJUMP]        = 10,
		[HARM_TYPE_SWORD]           = 10,
	}
)


ai.registerThrown(npcID)


yoshi.tongueSettings.thrownEggNPCID = npcID


return egg