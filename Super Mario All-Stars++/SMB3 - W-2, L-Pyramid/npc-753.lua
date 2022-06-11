--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local utils = require("npcs/npcutils")

local ceilingBeetleAI = require("ceilingbeetle")

--Create the library table
local ceilingBeetle = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local ceilingBeetleSettings = {
	id = npcID,
	
	gfxheight = 32,
	gfxwidth = 32,

	width = 32,
	height = 32,
	
	gfxoffsetx = 0,
	gfxoffsety = 0,

	frames = 2,
	framestyle = 1,
	framespeed = 8, 

	speed = 1,

	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,

	nohurt=false,
	nogravity = true,
	noblockcollision = false,
	nofireball = false,
	noiceball = false,
	noyoshi= false,
	nowaterphysics = false,
	
	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	--NPC-specific properties
	--xspeed = 1.2, --Horizontal speed
	--activeradius = 64, --The max distance in which the enemy will starts dropping down.
	--droppedID = 752, --Dropped Shell ID. Default is npcID+1. Uncomment this and change manually if otherwise.
	--deathEffectID = 751, --Death effect ID. Default is npcID. Uncomment this and change manually if otherwise.
}

--Applies NPC settings
npcManager.setNpcSettings(ceilingBeetleSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
ceilingBeetleAI.registerHarmTypes(npcID,ceilingBeetleSettings["deathEffectID"] or npcID)

--Register events
ceilingBeetleAI.register(npcID,ceilingBeetleSettings["droppedID"] or npcID+1)

--Gotta return the library table!
return ceilingBeetle