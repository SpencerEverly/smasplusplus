--[[

	Written by MrDoubleA
	Please give credit!

    Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local ai = require("subspace_ai")


local subspace = {}
local npcID = NPC_ID

local subspaceSettings = {
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
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = true, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = true, --Also handles other NPCs walking atop this NPC.

	nohurt = true,
	nogravity = false,
	noblockcollision = false,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = true,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = true,
	harmlessthrown = true,

	ignorethrownnpcs = true,
	grabtop = true,

	subspacebehaviour = 2, -- subspace only
}

npcManager.setNpcSettings(subspaceSettings)
npcManager.registerHarmTypes(npcID,{},{})


function subspace.onInitAPI()
	npcManager.registerEvent(npcID, subspace, "onTickEndNPC")
end


local function canCollectMushroom(p)
	return (
		p.forcedState == FORCEDSTATE_NONE
		and p.deathTimer == 0
		and not p:mem(0x13C,FIELD_BOOL)
	)
end


function subspace.onTickEndNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v.despawnTimer <= 0 then
		data.initialized = false
		return
	end

	local config = NPC.config[v.id]

	if not data.initialized then
		data.initialized = true
	end


	if v:mem(0x12C,FIELD_WORD) > 0 then
		local p = Player(v:mem(0x12C,FIELD_WORD))

		if p.isValid and canCollectMushroom(p) then
			-- There's not really a convenient way to just give the player a mushroom so this'll do
			local mushroom = NPC.spawn(9,p.x + p.width*0.5,p.y + p.height*0.5,p.section,false,false)

			mushroom.width = 1
			mushroom.height = 1

			mushroom.animationFrame = -9999

			v:kill(HARM_TYPE_VANISH)
			v.animationFrame = -9999
		end
	elseif v:mem(0x12C,FIELD_WORD) == 0 and v:mem(0x138,FIELD_WORD) == 0 and v.collidesBlockBottom then
		v.speedX = 0
	end
end

return subspace