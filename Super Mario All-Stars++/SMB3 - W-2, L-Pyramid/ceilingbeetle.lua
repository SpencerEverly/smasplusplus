local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local ceilingBeetle = {}

local beetleNPC = {}
local shellNPC = {}

function ceilingBeetle.onInitAPI()
	registerEvent(ceilingBeetle, "onNPCHarm","onShellNPCHarm")
end

--[[=========================================================
					Ceiling Beetles Handler
=============================================================]]

function ceilingBeetle.registerHarmTypes(npcID,deathID)
	npcManager.registerHarmTypes(npcID,
	{
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
	}, 
	{
		[HARM_TYPE_NPC]=deathID,
		[HARM_TYPE_PROJECTILE_USED]=deathID,
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]=deathID,
	}
	);
end

function ceilingBeetle.register(npcID,transformedID)
	beetleNPC[npcID] = transformedID
	npcManager.registerEvent(npcID, ceilingBeetle, "onTickEndNPC")
end

function ceilingBeetle.onTickEndNPC(v)
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
		
		--Load all the configuables
		data.xspeed = NPC.config[v.id].xspeed or 1.2
		
		data.activeradius = NPC.config[v.id].activeradius or 64
		
		data.forceDrop = false
		
		data.justTurned = false
		
		
		
		--I'm not sure why, but the speed is apparently non-zero at the start and it caused a problem later on
		v.speedY = 0
		
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
	
	local player = npcutils.getNearestPlayer(v)
	
	if math.abs((player.x + 0.5 * player.width) - (v.x + 0.5 * v.width))<data.activeradius or data.forceDrop then
		v.data.initialized = false
		v.speedX = 0.001 --small non-zero speed so the player cannot grab shells
		v:transform(beetleNPC[v.id])
		return
	end
	
	
	v.speedX = v.direction * data.xspeed
	
	--Ceiling Collision Check based on Polflip by Enjl
	local collidesUp = false

	if v.dontmove then return end

    for k,b in ipairs(Block.getIntersecting(v.x + 0.5 * v.width + v.direction, v.y - 1, v.x + 0.5 * v.width + v.direction + 1, v.y)) do
        if Block.SOLID_MAP[b.id] and b:mem(0x5c, FIELD_WORD) == 0 and not v.isHidden then
            collidesUp = true
            break
        end
    end
	
	if not collidesUp then
		v.direction = -v.direction
		
		--Check if it has already turned or not in the last frame
		--If it is, then force it to drop down the ceiling
		if not data.justTurned then
			data.justTurned = true
		else
			data.forceDrop = true
		end
		
	else
		data.justTurned = false
	end
	
end

--[[=========================================================
					Beetle Shell Handler
=============================================================]]

function ceilingBeetle.registerShellNPC(npcID)
	shellNPC[npcID] = true
	
	npcManager.registerEvent(npcID, ceilingBeetle, "onTickNPC","onTickShellNPC")
	npcManager.registerEvent(npcID, ceilingBeetle, "onDrawNPC","onDrawShellNPC")
end

function ceilingBeetle.registerHarmTypeShell(npcID,deathID)
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
		[HARM_TYPE_NPC]=deathID,
		[HARM_TYPE_PROJECTILE_USED]=deathID,
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]=deathID,
		[HARM_TYPE_SWORD]=10,
	}
);
end


function ceilingBeetle.onTickShellNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	--If despawned
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		--Reset our properties, if necessary
		if data.dontmoveshell then
			v.dontMove = true
		end
		
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		data.isdropped = true
		
		data.xspeed = NPC.config[v.id].xspeed or 2.7
		
		--Shell NPC does not work very well with dontMove.
		--This simply just remove dontMove property and set the shell speed to 0 to mimic static shell
		if v.dontMove then
			data.xspeed = 0
			data.dontmoveshell = true --A marker to keep track if the shell is actually a "don't move" variant or not.
			v.dontMove = false
		end
		
		data.initialized = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
		if data.isdropped then
			data.isdropped = false
		end
	end
	
	if data.isdropped and v.collidesBlockBottom then
		data.isdropped = false
		npcutils.faceNearestPlayer(v)
		
		v.speedX = data.xspeed * v.direction
	end
	
end

function ceilingBeetle.onDrawShellNPC(v)
	if v.speedX == 0 then
		v.animationFrame = 0
	end
end

-- Taken from Yoshi021's Bombshell Koopa AI, which also credits to Mr.DoubleA
-- This mimics Koopa Shell Behavior

local THROWN_NPC_COOLDOWN    = 0x00B2C85C
local SHELL_HORIZONTAL_SPEED = 0x00B2C860
local SHELL_VERTICAL_SPEED   = 0x00B2C864

function ceilingBeetle.onShellNPCHarm(eventObj,v,reason,culprit)
	if not shellNPC[v.id] then return end

	local culpritIsPlayer = (culprit and culprit.__type == "Player")
	local culpritIsNPC    = (culprit and culprit.__type == "NPC"   )

	--[[if v.data.isdropped then
		v.data.isdropped = false
	end]]

	if reason == HARM_TYPE_JUMP then
		if v:mem(0x138,FIELD_WORD) == 2 then
			v:mem(0x138,FIELD_WORD,0)
		end

		if culpritIsPlayer and culprit:mem(0xBC,FIELD_WORD) <= 0 and culprit.mount ~= 2 then
			if v.speedX == 0 and (culpritIsPlayer and v:mem(0x130,FIELD_WORD) ~= culprit.idx)  then
				SFX.play(9)
				v.speedX = mem(SHELL_HORIZONTAL_SPEED,FIELD_FLOAT)*culprit.direction
				v.speedY = 0

				v:mem(0x12E,FIELD_WORD,mem(THROWN_NPC_COOLDOWN,FIELD_WORD))
				v:mem(0x130,FIELD_WORD,culprit.idx)
				v:mem(0x132,FIELD_BOOL,true)
			elseif (culpritIsPlayer and v:mem(0x130,FIELD_WORD) ~= culprit.idx) or (v:mem(0x22,FIELD_WORD) == 0 and (culpritIsPlayer and culprit:mem(0x40,FIELD_WORD) == 0)) then
				SFX.play(2)
				v.speedX = 0
				v.speedY = 0

				if v:mem(0x1C,FIELD_WORD) > 0 then
					v:mem(0x18,FIELD_FLOAT,0)
					v:mem(0x132,FIELD_BOOL,true)
				end
			end
		end
	elseif reason == HARM_TYPE_FROMBELOW or reason == HARM_TYPE_TAIL then
		SFX.play(9)

		v:mem(0x132,FIELD_BOOL,true)
		v.speedY = -5
		v.speedX = 0
	elseif reason == HARM_TYPE_LAVA then
		v:mem(0x122,FIELD_WORD,reason)
	elseif reason ~= HARM_TYPE_PROJECTILE_USED and v:mem(0x138, FIELD_WORD) ~= 4 then
		if reason == HARM_TYPE_NPC then
			if not (v.id == 24 and culpritIsNPC and (culprit.id == 13 or culprit.id == 108)) then
				v:mem(0x122,FIELD_WORD,reason)
			end
		else
			v:mem(0x122,FIELD_WORD,reason)
		end
	elseif reason == HARM_TYPE_PROJECTILE_USED then
		if culpritIsNPC and culprit:mem(0x132,FIELD_BOOL) and (culprit.id < 117 or culprit.id > 120) then
			v:mem(0x122,FIELD_WORD,reason)
		end
	end

	eventObj.cancelled = true
end

--Gotta return the library table!
return ceilingBeetle