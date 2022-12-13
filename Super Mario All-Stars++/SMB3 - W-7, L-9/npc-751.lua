--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

--Create the library table
local flameChomp = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local flameChompSettings = {
	id = npcID,
	gfxheight = 32,
	gfxwidth = 32,
	width = 32,
	height = 32,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 5,
	framestyle = 1,
	framespeed = 8,
	speed = 1,

	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,

	nohurt=false,
	nogravity = true,
	noblockcollision = true,
	nofireball = false,
	noiceball = true,
	noyoshi= false,
	nowaterphysics = false,
	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	grabside=false,
	grabtop=false,
	
	--NPC-specific properties
	--tailID = 752, --Tail NPC ID, default being npcID+1. Uncomment and set this manually otherwise
	--projectileID = 753,  --Projectile NPC ID, default being npcID+2. Uncomment and set this manually otherwise
	--closeness = 8, --Closeness between each fireball tail
	--acceleration = 0.0648,
	--maxspeed = 2,
}

--Applies NPC settings
npcManager.setNpcSettings(flameChompSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_JUMP,
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_HELD,
		HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
		HARM_TYPE_SWORD
	}, 
	{
		[HARM_TYPE_HELD]=10,
		[HARM_TYPE_SPINJUMP]=10,
	}
);

--Custom local definitions below
local STATE_CHASE = 0
local STATE_SPLIT = 1
local STATE_EXPLODE = 2
local STATE_DEAD = 3

--Register events
function flameChomp.onInitAPI()
	npcManager.registerEvent(npcID, flameChomp, "onTickNPC")
	npcManager.registerEvent(npcID, flameChomp, "onDrawNPC")
	registerEvent(flameChomp, "onNPCKill")
end

function flameChomp.onDrawNPC(v)
	if Defines.levelFreeze then return end
	
	--if despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then return end
	
	local data = v.data
	
	local f = 0
	
	if data.state == STATE_CHASE then
		f = 0
	elseif data.state == STATE_SPLIT then
		if data.timer < 24 then
			f = 2
		else
			f = 1
		end
	elseif data.state == STATE_EXPLODE then
		if data.explosionFrame then
			f = 3
		else
			f = 0
		end
	elseif data.state == STATE_DEAD then
		f = 4
	end
	
	v.animationFrame = npcutils.getFrameByFramestyle(v, {frame=f})
	
end

function flameChomp.onTickNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	--If despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		--Reset our properties, if necessary
		
		for i=#data.tailObject,1,-1 do
			if data.tailObject[i].isValid then
				data.tailObject[i]:kill(HARM_TYPE_OFFSCREEN)
			end
		end
		
		data.tailObject = {}
		
		--Reset Friendly Property for respawning dead ones
		if data.state==STATE_DEAD then
			v.friendly = false
		end
		
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		
		local cfg = NPC.config[v.id]
		
		data.tailID = cfg.tailID or npcID+1

		data.tailWidth = NPC.config[data.tailID].width*0.5
		data.tailHeight = NPC.config[data.tailID].height*0.5
		
		data.closeness = cfg.closeness or 8
		
		data.projectileID = NPC.config[v.id].projectileID or npcID+2
		
		data.state = STATE_CHASE
		
		data.follower = data._settings.length or 4
		data.tailObject = {}
		
		data.maxHistoryCount = math.max(data.follower*data.closeness,1)
		
		data.tailHistory = {}
		
		for i=1,data.follower do
			s = NPC.spawn(data.tailID, v.x, v.y, v.section, false, true)
			data.tailObject[i] = s
		end
		
		for i=1,data.maxHistoryCount do
			data.tailHistory[i] = {x = v.x + data.tailWidth, y = v.y+ data.tailHeight}
		end
		
		data.acceleration = cfg.acceleration or 0.0648
		data.maxv = cfg.maxspeed or 2
		
		data.homingDist = 1
		
		data.timer = 150
		
		data.explosionFrame = false
		
		data.initialized = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
		data.holding = true
	end
	
	--Execute main AI. This template just jumps when it touches the ground.
	if data.state == STATE_CHASE then
		
		if not data.holding then
		data.timer = data.timer-1
		end
		
		if data.timer<=0 then
			data.state = STATE_SPLIT
			data.timer = 32
			
			v.speedX = 0
			v.speedY = 0
			
			if data.follower>0 then
				if data.tailObject[data.follower].isValid then
					data.tailObject[data.follower]:kill(HARM_TYPE_OFFSCREEN)
					data.tailObject[data.follower] = nil
				end
				data.follower = data.follower-1
			else
				data.state = STATE_EXPLODE
				data.timer = 80
			end

		end
	elseif data.state == STATE_SPLIT then
		
		data.timer = data.timer-1
		
		if data.timer==24 then
			SFX.play(16)
		
			local w = NPC.spawn(data.projectileID, v.x+0.5*v.width, v.y+0.5*v.height, v.section, false, true)
			local aimang = math.atan2(player.y-v.y,player.x-v.x)
			w.speedX = 2.5*math.cos(aimang)
			w.speedY = 2.5*math.sin(aimang)
			w.layerName = "Spawned NPCs"
			w.friendly = v.friendly
			
		end
		
		if data.timer<=0 then
			data.state = STATE_CHASE
			data.timer = 150
		end
	
	elseif data.state == STATE_EXPLODE then
		
		data.timer = data.timer-1
		
		if data.timer%8 == 0 then
			data.explosionFrame = not data.explosionFrame
		end
		
		if data.timer<=0 then
			Explosion.spawn(v.x+0.5*v.width, v.y+0.5*v.height, 3)
			v:kill(HARM_TYPE_OFFSCREEN)
		end
		
	elseif data.state == STATE_DEAD then
		
		data.ang = data.ang+0.2
		v.speedX = 1*math.sin(data.ang)
		
		v.speedY = math.min(v.speedY+0.2,4)
	end
	
	if data.state == STATE_CHASE or data.state == STATE_EXPLODE then
	
		if not data.holding then
	
			--Homing X position
			local player = npcutils.getNearestPlayer(v)
		
			local distX = (player.x + 0.5 * player.width) - (v.x + 0.5 * v.width)
			
			if math.abs(distX)>data.homingDist then
				v.speedX = math.clamp(v.speedX + data.acceleration*math.sign(distX),-data.maxv,data.maxv)
			end
			
			--Homing Y position
		
			local distY = (player.y + 0.5 * player.height) - (v.y + 0.5 * v.height)
			
			if math.abs(distY)>data.homingDist then
				v.speedY = math.clamp(v.speedY + data.acceleration*math.sign(distY),-data.maxv,data.maxv)
			end
		else
		
			--Slow down the speed from throwing
			v.speedX = v.speedX*0.99
			
			if math.abs(v.speedX)<0.1 then
				v.speedX = 0
			end
			
			v.speedY = v.speedY*0.99
			
			if math.abs(v.speedY)<0.1 then
				v.speedY = 0
				data.holding = false
			end
			
		end
	end
	
	if data.maxHistoryCount<=1 then return end
	
	data.tailHistory[1].x = v.x + data.tailWidth
	data.tailHistory[1].y = v.y + data.tailHeight
	
	--Update Position History
	for i=data.maxHistoryCount-1,1,-1 do
		data.tailHistory[i+1].x = data.tailHistory[i].x
		data.tailHistory[i+1].y = data.tailHistory[i].y
	end
	
	
	
	--Update Tail Position
	for i=#data.tailObject,1,-1 do
		if data.tailObject[i].isValid then
			data.tailObject[i].x = data.tailObject[i].x*0.7+data.tailHistory[i*data.closeness].x*0.3
			data.tailObject[i].y = data.tailObject[i].y*0.7+data.tailHistory[i*data.closeness].y*0.3
		end
	end
	
end

function flameChomp.onNPCKill(eventObj, v, killReason)
	if v.id~=npcID then return end
	
	local data = v.data
	
	if killReason == HARM_TYPE_OFFSCREEN or killReason == HARM_TYPE_SPINJUMP or killReason == HARM_TYPE_HELD then
		for i=#data.tailObject,1,-1 do
			if data.tailObject[i].isValid then
				Effect.spawn(10,data.tailObject[i].x,data.tailObject[i].y)
				data.tailObject[i]:kill(HARM_TYPE_OFFSCREEN)
			end
		end
		return
	end
	
	
	
	if data.state ~= STATE_DEAD then
	
		data.state = STATE_DEAD
		
		data.ang = 0
		
		v.friendly = true
		
		v.speedY = -6
		
		--Disable Respawning
		v:mem(0xDC, FIELD_WORD, 0)
		
		eventObj.cancelled = true
	else
		
	end
	
	
	return
	
end

--Gotta return the library table!
return flameChomp