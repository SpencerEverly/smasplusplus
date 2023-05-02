--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

--Create the library table
local microGoomba = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local microGoombaSettings = {
	id = npcID,
	gfxheight = 16,
	gfxwidth = 16,
	width = 16,
	height = 16,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 1,
	framestyle = 1,
	framespeed = 8,
	speed = 1,
	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,

	nohurt=true,
	nogravity = true,
	noblockcollision = true,
	nofireball = false,
	noiceball = false,
	noyoshi= true,
	nowaterphysics = true,
	
	ignorethrownnpcs = true,

	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	grabside=false,
	grabtop=false,

	--NPC-specific properties
	--fallspeed = 2, --Vertical falling speed
	--releaseTime = 180, --Total time (in frames) until the player can shake off the Goomba.
	--deathEffectID = 752, --Death Effect ID, default is the npcID. Uncomment this and set manually otherwise.
}

--Applies NPC settings
npcManager.setNpcSettings(microGoombaSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_LAVA,
	}, 
	{
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
	}
);

local deathEffectID = microGoombaSettings["deathEffectID"] or npcID

--Custom local definitions below
local STATE_FALL = 0
local STATE_ATTACH = 1

--Register events
function microGoomba.onInitAPI()
	npcManager.registerEvent(npcID, microGoomba, "onTickNPC")
	npcManager.registerEvent(npcID, microGoomba, "onDrawNPC")
end

function microGoomba.onTickNPC(v)
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
		
		data.releaseTime = NPC.config[v.id].releaseTime or 180
		
		data.state = STATE_FALL
		
		data.hostPlayer = -1
		
		data.attachtimer = 0
		
		data.ang = 0
		
		data.spawnX = v.x
		
		v.speedY = NPC.config[v.id].fallspeed or 2
		
		data.initialized = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	
	--Execute main AI.
	if data.state == STATE_FALL then
	
		data.ang = data.ang+0.1
		
		v.x = data.spawnX+16*math.sin(data.ang)
	
		if data.ang < math.pi then
			v.direction = -1
		elseif data.ang > math.pi*2 then
			data.ang = data.ang-math.pi*2
		else
			v.direction = 1
		end
		
		if v.friendly then return end
		
		local pl = Player.getIntersecting(v.x - 0.5 * v.width,v.y - 0.5 * v.height,v.x + 0.5 * v.width,v.y + 0.5 * v.height)
		
		if table.getn(pl)>0 then
			data.hostPlayer = pl[1]
			
			data.ang = 0
			
			data.state = STATE_ATTACH 
		end
	
	elseif data.state == STATE_ATTACH then
	
		local p = data.hostPlayer
	
		data.ang = data.ang+0.1
	
		v.x = p.x + 0.5* p.width * (1+math.sin(data.ang))-v.width*0.5
		v.y = p.y + 0.5*p.height * (1+math.sin(data.ang*0.125))-v.height
		
		data.attachtimer = data.attachtimer+1
		
		--Prevent Jumping. (Really Janky Solution)
		if p.speedY < 0 and not p:isGroundTouching() then
		
			--If enough timer pass, let player shake off the Goomba
			if data.attachtimer > data.releaseTime then
				microGoomba.detach(v)
			end
			
		
			p.y = p.y-p.speedY
			p.speedY = 6
		end
		
		--Player is swimming, invincible or dead - detach Goomba immediately
		if p:mem(0x34,FIELD_WORD)==2 or p:isInvincible() or p.deathTimer > 0 then
			microGoomba.detach(v)
		end
		
	end
end

function microGoomba.detach(v) 
	v:kill(HARM_TYPE_OFFSCREEN)
	--Create death effect
	Effect.spawn(deathEffectID, v.x, v.y)
end

function microGoomba.onDrawNPC(v)
	--If despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then return end
	
	local data = v.data
	
	if not data then return end
	
	if data.state==STATE_ATTACH and data.ang%(2*math.pi) < math.pi then
		npcutils.drawNPC(v,{priority = -5})
		npcutils.hideNPC(v)
	end
end

--Gotta return the library table!
return microGoomba