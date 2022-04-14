--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

--Create the library table
local brickGoomba = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

local goombaEffectID = npcID --Micro Goomba's Effect ID, default: same as NPC ID

--Defines NPC config for our NPC.
local brickGoombaSettings = {
	id = npcID,
	gfxheight = 38,
	gfxwidth = 32,
	width = 32,
	height = 32,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 3,
	framestyle = 0,
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

	jumphurt = false, 
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	--NPC-specific properties
	xspeed = 2,
	jumpspeed = -9,
	cooldowntime = 60,
	--activeradius = 64,
}

--Applies NPC settings
npcManager.setNpcSettings(brickGoombaSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_JUMP,
		HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		--HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_LAVA,
		--HARM_TYPE_HELD,
		HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD
	}, 
	{
		[HARM_TYPE_JUMP]=1,
		[HARM_TYPE_FROMBELOW]=1,
		[HARM_TYPE_NPC]=1,
		--[HARM_TYPE_PROJECTILE_USED]=1,
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		--[HARM_TYPE_HELD]=10,
		[HARM_TYPE_TAIL]=1,
		[HARM_TYPE_SPINJUMP]=1,
		--[HARM_TYPE_OFFSCREEN]=10,
		[HARM_TYPE_SWORD]=1,
	}
);

--Custom local definitions below
local STATE_IDLE = 0
local STATE_READY = 1
local STATE_JUMP = 2
local STATE_COOLDOWN = 3


--Register events
function brickGoomba.onInitAPI()
	npcManager.registerEvent(npcID, brickGoomba, "onTickNPC")
	npcManager.registerEvent(npcID, brickGoomba, "onDrawNPC")
	registerEvent(brickGoomba, "onNPCKill")
end

function brickGoomba.onTickNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	local cfg = NPC.config[v.id]
	
	--If despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		--Reset our properties, if necessary
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		
		data.timer = 0 --animation timer
		data.state = STATE_IDLE
		
		--Set defaults for customizable parameters
		data.xspeed = cfg.xspeed or 2
		data.jumpspeed = cfg.jumpspeed or -9
		data.cooldowntime = cfg.cooldowntime or 60
		data.activeradius = cfg.activeradius or 64
		
		data.initialized = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
		data.holding = true
	else
		if data.holding then
			data.holding = false
		end
	end
	
	
	--Execute main AI.
	
	if data.state==STATE_IDLE then
	
		if math.abs(v.speedX) > 0 then
			v.speedX = v.speedX*0.95
			
		elseif math.abs(v.speedX) < 0.5 then
			v.speedX = 0
		end
	
		if not data.holding then
			local player = npcutils.getNearestPlayer(v)
			if math.abs(player.x-v.x)<=data.activeradius then
				data.state=STATE_READY
				npcutils.faceNearestPlayer(v)
			end
		end
	elseif data.state ==STATE_READY then
		data.timer = data.timer+1
		if data.timer>32 then
			data.state=STATE_JUMP
			data.timer = 0
			
			v.speedY = data.jumpspeed
			v.speedX = v.direction*data.xspeed
		end
	elseif data.state ==STATE_JUMP then
		
		if v.collidesBlockBottom then
			data.state=STATE_COOLDOWN
			v.speedX = 0
			data.timer = data.cooldowntime
			SFX.play(37)
		end
	elseif data.state ==STATE_COOLDOWN then
		data.timer = data.timer-1
		if data.timer<=0 then
			data.state=STATE_IDLE
			data.timer = 0
		end
	end
	
end

function brickGoomba.onDrawNPC(v)

	if v:mem(0x12A, FIELD_WORD) <= 0 then return end

	local data = v.data
	
	local f = 0
	
	if data.state==STATE_IDLE then
		f = 0
	elseif data.state==STATE_READY then
	
		if data.timer < 24 then
			f = math.floor(data.timer/8)%3
		else
			f = 1
		end
		
	elseif data.state==STATE_JUMP then
		if v.speedY < 0 then
			f = 1
		else
			f = 0
		end
	end
	
	v.animationFrame = f
end

function brickGoomba.onNPCKill(eventObj,v,killReason,culprit)
	if v.id ~= npcID then return end
	
	--If it's killed by these types, spawn extra effect and play proper SFX
	if killReason==HARM_TYPE_JUMP or killReason==HARM_TYPE_FROMBELOW or killReason==HARM_TYPE_NPC
	or killReason==HARM_TYPE_TAIL or killReason==HARM_TYPE_SPINJUMP or killReason==HARM_TYPE_SWORD then
	SFX.play(4)
	
	local e = Effect.spawn(goombaEffectID, v.x, v.y)
	e.speedX = 0
	end

end

--Gotta return the library table!
return brickGoomba