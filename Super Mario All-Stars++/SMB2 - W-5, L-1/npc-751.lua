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

local defaultSpawnID = (npcID+1)

local subspaceSettings = {
	id = npcID,
	
	gfxwidth = 32,
	gfxheight = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 32,
	
	frames = 4,
	framestyle = 0,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt = true,
	nogravity = false,
	noblockcollision = false,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = false,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = true,
	harmlessthrown = true,

	grabside = true,
	ignorethrownnpcs = true,


	defaultSpawnID = defaultSpawnID,
	
	spawnEffectID = 147,
	spawnEffectDuration = 16,


	lightradius = 64,
	lightbrightness = 1,
	lightoffsetx = 0,
	lightoffsety = 0,
	lightcolor = Color.orange,
}

npcManager.setNpcSettings(subspaceSettings)
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_LAVA,
		HARM_TYPE_OFFSCREEN,
	},
	{
		[HARM_TYPE_LAVA] = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
	}
)


local function spawnEffects(effectID,x,y,width,height)
	local effectConfig = Effect.config[effectID][1]

	local effectWidth = effectConfig.width
	local effectHeight = effectConfig.height

	local effectCountX = math.floor(width /effectWidth  + 0.5)
	local effectCountY = math.floor(height/effectHeight + 0.5)

	for idxX = 1,effectCountX do
		for idxY = 1,effectCountY do
			local effectX = x - effectCountX*effectWidth *0.5 + (idxX-1)*effectWidth
			local effectY = y - effectCountY*effectHeight*0.5 + (idxY-1)*effectHeight

			Effect.spawn(effectID,effectX,effectY)
		end
	end

	--Colliders.Box(x - effectCountX*effectWidth *0.5,y - effectCountY*effectHeight*0.5,effectCountX*effectWidth,effectCountY*effectHeight):Debug(true)
end

local function getGravity(v,data,config)
	local gravity = Defines.npc_grav

	if config.nogravity then
		gravity = 0
	elseif v.underwater and not config.nowaterphysics then
		gravity = gravity * 0.2
	end

	return gravity
end

local function setForcedState(v)
	v:mem(0x138,FIELD_WORD,8) -- invisible forced state
	v:mem(0x13C,FIELD_DFLOAT,10) -- forced state timer 1
end


function subspace.onInitAPI()
	npcManager.registerEvent(npcID, subspace, "onTickNPC")
end

function subspace.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v.despawnTimer <= 0 then
		data.initialized = false
		return
	end

	local config = NPC.config[v.id]

	if not data.initialized then
		data.initialized = true

		data.holdingPlayer = 0

		data.spawnTimer = 0

		data.hasBeenProjectile = false

		data.releaseTimer = 0

		data.spawnID = v.ai1
		if data.spawnID <= 0 then
			data.spawnID = config.defaultSpawnID
		end
	end


	if data.spawnTimer > 0 then
		data.spawnTimer = data.spawnTimer - 1

		if data.spawnTimer <= 0 then
			local spawnConfig = NPC.config[data.spawnID]
			local npc = NPC.spawn(data.spawnID,v.x + v.width*0.5,v.y + v.height - spawnConfig.height*0.5,v.section,false,true)

			npc.direction = v.direction

			v:kill(HARM_TYPE_VANISH)
		end

		setForcedState(v)

		return
	end


	if v:mem(0x136,FIELD_BOOL) then
		data.hasBeenProjectile = true
	end

	if v:mem(0x12C,FIELD_WORD) > 0 then
		data.holdingPlayer = v:mem(0x12C,FIELD_WORD)
		data.hasBeenProjectile = true
		data.releaseTimer = 0
		return
	elseif v:mem(0x138,FIELD_WORD) > 0 then
		data.releaseTimer = 0
		return
	end


	-- Timer used to prevent it from thinking it's on ground when it really isn't
	data.releaseTimer = data.releaseTimer + 1


	-- Custom releasing
	if data.holdingPlayer > 0 then
		local p = Player(data.holdingPlayer)

		if p.isValid then
			if not p.keys.up then
				if p.direction == DIR_RIGHT then
					v.x = p.x + p.width + 4
				else
					v.x = p.x - v.width - 4
				end

				v.speedY = 0
			end

			if not p.keys.left and not p.keys.right then
				v.speedX = 0
			end

			SFX.play(75)
		end

		data.holdingPlayer = 0
	end
	

	if v.collidesBlockBottom and data.hasBeenProjectile and data.releaseTimer > 1 then
		local spawnConfig = NPC.config[data.spawnID]

		spawnEffects(config.spawnEffectID,v.x + v.width*0.5,v.y + v.height - spawnConfig.height*0.5,spawnConfig.width,spawnConfig.height)
		data.spawnTimer = config.spawnEffectDuration

		setForcedState(v)

		SFX.play(41)
	end
end

return subspace