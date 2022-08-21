--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

--Create the library table
local paraGoomba = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local paraGoombaSettings = {
	id = npcID,
	
	gfxheight = 48,
	gfxwidth = 40,
	
	width = 32,
	height = 32,
	
	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	frames = 4,
	framestyle = 0,
	framespeed = 8,
	
	speed = 1,

	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,

	nohurt=false,
	nogravity = false,
	noblockcollision = false,
	nofireball = false,
	noiceball = false,
	noyoshi= false,
	nowaterphysics = true,
	
	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	grabside=false,
	grabtop=false,

	--NPC-specific properties
	--xspeed = 2, --Max horizontal speed. Default is 2
	--homingdist = 32, --Max horizontal distance before the Goomba home into the player's x position. Default is 32 (1 tile)
	--deathEffectID = 4, --Death effect ID, default is 4 (SMB3 Goomba's Death Effect). Uncomment this and set manually otherwise.
	--goombaNPCID = 1, --NPC ID for base goomba, default is 1 (SMB3 Goomba) Uncomment this and set manually otherwise.
	
}

local deathEffectID = paraGoombaSettings["deathEffectID"] or 4
local goombaID = paraGoombaSettings["goombaNPCID"] or 1

--Applies NPC settings
npcManager.setNpcSettings(paraGoombaSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_JUMP,
		HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
		HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
		HARM_TYPE_SWORD
	}, 
	{
		[HARM_TYPE_JUMP]=10,
		[HARM_TYPE_FROMBELOW]={id=deathEffectID,xoffset=1},
		[HARM_TYPE_NPC]={id=deathEffectID,xoffset=1},
		[HARM_TYPE_PROJECTILE_USED]={id=deathEffectID,xoffset=1},
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]={id=deathEffectID,xoffset=1},
		[HARM_TYPE_TAIL]={id=deathEffectID,xoffset=1},
		[HARM_TYPE_SPINJUMP]=10,
		[HARM_TYPE_SWORD]=10,
	}
);

--Custom local definitions below
local STATE_ASCEND = 0
local STATE_FLYING = 1
local STATE_DESCEND = 2
local STATE_GROUNDED = 3

--Register events
function paraGoomba.onInitAPI()
	npcManager.registerEvent(npcID, paraGoomba, "onTickNPC")
	npcManager.registerEvent(npcID, paraGoomba, "onDrawNPC")
	registerEvent(paraGoomba, "onNPCKill")
end

function paraGoomba.onDrawNPC(v)
	if Defines.levelFreeze then return end
	
	--if despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then return end
	
	local data = v.data
	
	local f = 0
	
	if data.state==STATE_ASCEND or data.state==STATE_DESCEND  then
		f = npcutils.getFrameByFramestyle(v, {offset=2,frames=2})
	elseif data.state==STATE_FLYING then
		f = npcutils.getFrameByFramestyle(v, {frames=4})
	elseif data.state==STATE_GROUNDED then
		f = npcutils.getFrameByFramestyle(v, {frames=2})
	end
	
	v.animationFrame = f
end

function paraGoomba.onTickNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	--If despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		--Reset our properties, if necessary
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		
		data.state = STATE_ASCEND
		
		data.xspeed = NPC.config[v.id].xspeed or 2
		data.homingDist = NPC.config[v.id].homingdist or 32
		
		data.peaky = 0
		
		data.ang = 0
		
		data.timer = 56
		
		data.initialized = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
		data.state = STATE_GROUNDED
		return;
	end
	
	--Execute main AI.
	if data.state == STATE_ASCEND then
	
		v.speedY = -5
		
		if data.timer<=0 then
			data.timer = 240
			data.state = STATE_FLYING
			data.peaky = v.y
			return;
		end
	
	elseif data.state == STATE_FLYING then
	
		data.ang = data.ang+0.2
		
		v.speedY = 0
		v.y = data.peaky+4*math.sin(data.ang)
		
		if data.timer<=0 then
			data.state = STATE_DESCEND
			return;
		end
		
		if data.timer%48==0 then
			local w = NPC.spawn(754,v.x+0.5*v.width,v.y+0.5*v.height,v.section,false,true)
			w.friendly = v.friendly
			w.layerName = "Spawned NPCs"
		end
	
	elseif data.state == STATE_DESCEND then
	
		if v.speedY < -4 then
			v.speedY = -4
		end
	
		if v.collidesBlockBottom then
			data.state = STATE_GROUNDED
			data.timer = 100
			return;
		end
	
	elseif data.state == STATE_GROUNDED then
		if data.timer<=0 then
			data.timer = 56
			data.state = STATE_ASCEND
			return;
		end
	end
	
	--Homing X position
	local player = npcutils.getNearestPlayer(v)
	
	local dist = (player.x + 0.5 * player.width) - (v.x + 0.5 * v.width)
	
	if math.abs(dist)>data.homingDist then
		v.speedX = math.clamp(v.speedX + 0.1*math.sign(dist),-data.xspeed,data.xspeed)
	end
	
	data.timer = data.timer - 1
end

function paraGoomba.onNPCKill(eventObj,v,killReason)
	if v.id ~= npcID then return end

	if killReason==HARM_TYPE_JUMP then
		eventObj.cancelled = true
		v:transform(goombaID)
	end
end

--Gotta return the library table!
return paraGoomba