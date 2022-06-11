--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local ceilingBeetleAI = require("ceilingbeetle")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
	id = npcID,

	gfxheight = 32,
	gfxwidth = 32,

	width = 32,
	height = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,

	frames = 4,
	framestyle = 0,
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
	noiceball = false,
	noyoshi= false,
	nowaterphysics = false,

	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	grabside=false,
	grabtop=false,

	isshell = true,

	--NPC-specific properties
	--xspeed = 2.7, --Horizontal speed for chasing the first time after dropped from the ceiling
	--deathEffectID = 751, --Death effect ID. Default is npcID-1
}

--Applies NPC settings
npcManager.setNpcSettings(sampleNPCSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
ceilingBeetleAI.registerHarmTypeShell(npcID, sampleNPCSettings["deathEffectID"] or npcID-1)

--Register events
ceilingBeetleAI.registerShellNPC(npcID)


--Gotta return the library table!
return sampleNPC