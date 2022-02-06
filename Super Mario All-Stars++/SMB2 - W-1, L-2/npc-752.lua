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
	gfxheight = 64,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 64,
	
	frames = 6,
	framestyle = 0,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

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


	openingFrames = 5,


	lightradius = 80,
	lightbrightness = 1,
	lightoffsetx = 0,
	lightoffsety = 0,
	lightcolor = Color.orange,
}

npcManager.setNpcSettings(subspaceSettings)
npcManager.registerHarmTypes(npcID,{},{})


function subspace.onInitAPI()
	npcManager.registerEvent(npcID, subspace, "onTickEndNPC")
	npcManager.registerEvent(npcID, subspace, "onDrawNPC")
end


local function canEnterDoor(p)
	return (
		p.forcedState == FORCEDSTATE_NONE
		and p.deathTimer == 0
		and not p:mem(0x13C,FIELD_BOOL)

		and not p.isMega
		and not p.climbing
		and p.mount ~= MOUNT_CLOWNCAR

		and not p:mem(0x0C,FIELD_BOOL) -- fairy
		and not p:mem(0x44,FIELD_BOOL) -- rainbow shell
		and not p:mem(0x5C,FIELD_BOOL) -- yoshi ground pound
		and p:mem(0x15C,FIELD_WORD) == 0 -- warp cooldown
	)
end


local function handleAnimation(v,data,config)
	local normalFrames = (config.frames - config.openingFrames)
	local frame = 0

	if data.beingUsed then
		frame = math.floor((data.useTimer / (ai.doorUseDuration*0.5)) * config.openingFrames)

		if data.useTimer > ai.doorUseDuration*0.5 then
			frame = config.openingFrames - (frame - config.openingFrames) - 2
		end

		frame = math.clamp(frame,0,config.openingFrames-1) + normalFrames
	else
		frame = math.floor(data.animationTimer / config.framespeed) % normalFrames
	end

	data.animationTimer = data.animationTimer + 1

	v.animationFrame = npcutils.getFrameByFramestyle(v,{frame = frame})
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

		data.animationTimer = 0

		data.beingUsed = false
		data.useTimer = 0
	end


	npcutils.applyLayerMovement(v)


	if v:mem(0x12C,FIELD_WORD) == 0 and v:mem(0x138,FIELD_WORD) == 0 then
		local x1 = v.x + v.width*0.5 - 0.5
		local x2 = v.x + v.width*0.5 + 0.5
		local y1 = v.y + v.height - 1
		local y2 = v.y + v.height

		for _,p in ipairs(Player.getIntersecting(x1,y1,x2,y2)) do
			if p.keys.up and canEnterDoor(p) then
				local successful = ai.startEnteringDoor(p,v)

				if successful then
					data.beingUsed = true
					data.useTimer = 0
				end
			end
		end
	end

	if data.beingUsed then
		data.useTimer = data.useTimer + 1

		if data.useTimer >= ai.doorUseDuration then
			data.beingUsed = false
		end
	end


	handleAnimation(v,data,config)
end


function subspace.onDrawNPC(v)
	if v.despawnTimer <= 0 or v.isHidden then return end

	npcutils.drawNPC(v,{priority = -76})
	npcutils.hideNPC(v)
end


return subspace