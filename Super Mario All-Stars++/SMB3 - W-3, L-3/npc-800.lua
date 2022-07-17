--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local utils = require("npcs/npcutils")
--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
	id = npcID,
	--Sprite size
	gfxheight = 64,
	gfxwidth = 48,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 48,
	height = 64,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 0,
	--Frameloop-related
	frames = 5,
	framestyle = 1,
	framespeed = 6, --# frames between frame change
	--Movement speed. Only affects speedX by default.
	speed = 1,
	--Collision-related
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.
	staticdirection = true,
	
	nohurt=false,
	nogravity = false,
	noblockcollision = true,
	nofireball = false,
	noiceball = true,
	noyoshi= false,
	nowaterphysics = true,
	--Various interactions
	jumphurt = true, --If true, spiny-like
	spinjumpsafe = true, --If true, prevents player hurt when spinjumping
	harmlessgrab = false, --Held NPC hurts other NPCs if false
	harmlessthrown = false, --Thrown NPC hurts other NPCs if false

	grabside=false,
	grabtop=false,

	--Identity-related flags. Apply various vanilla AI based on the flag:
	--iswalker = false,
	--isbot = false,
	--isvegetable = false,
	--isshoe = false,
	--isyoshi = false,
	--isinteractable = false,
	--iscoin = false,
	--isvine = false,
	--iscollectablegoal = false,
	--isflying = false,
	--iswaternpc = false,
	--isshell = false,

	--Emits light if the Darkness feature is active:
	--lightradius = 100,
	--lightbrightness = 1,
	--lightoffsetx = 0,
	--lightoffsety = 0,
	--lightcolor = Color.white,

	--Define custom properties below
}

--Applies NPC settings
npcManager.setNpcSettings(sampleNPCSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		--HARM_TYPE_JUMP,
		--HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
		--HARM_TYPE_TAIL,
		--HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD
	}, 
	{
		--[HARM_TYPE_JUMP]=10,
		--[HARM_TYPE_FROMBELOW]=10,
		[HARM_TYPE_NPC]=800,
		[HARM_TYPE_PROJECTILE_USED]=800,
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]=800,
		--[HARM_TYPE_TAIL]=10,
		--[HARM_TYPE_SPINJUMP]=10,
		--[HARM_TYPE_OFFSCREEN]=10,
		--[HARM_TYPE_SWORD]=10,
	}
);

--Custom local definitions below

--Register events
function sampleNPC.onInitAPI()
	npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
	--npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
	npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
	--registerEvent(sampleNPC, "onNPCKill")
end

function sampleNPC.onTickEndNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	local jumpbox = Colliders.Box(v.x - (v.width * 2), v.y - (v.height) - 60, v.width * 4, 204)
	--jumpbox:debug(true)
	local mouthbox = Colliders.Box(v.x + (v.width / 4) + (v.width / 4 * v.direction) - 8, v.y + (v.height / 2) - 8, v.width / 2 + 16, v.height / 2 + 16)
	--mouthbox:debug(true)
	
	--If despawned
	if v.despawnTimer <= 0 then
		--Reset our properties, if necessary
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		data.initialized = true
		eatenplayer = 0
		jumpbox:debug(false)
		v.ai1 = 0 --Current state
		v.ai2 = 40 --Timer
		v.ai3 = false --Did the player get eaten?
		v.ai4 = v.y --Initial spawn position, used after it dives back into the water
		v.ai5 = 0
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	
	--Execute main AI. This template just jumps when it touches the ground.	
	v.ai2 = v.ai2 + 1
	
	if v.ai1 == 0 then
		if player.x < v.x - 280 then
			v.direction = -1
		elseif player.x > v.x + 280 then
			v.direction = 1
		end
		
		v.speedX = math.clamp(v.speedX + .5 * v.direction, -6, 6)
		v.speedY = -Defines.npc_grav
		if Colliders.collide(player, jumpbox) and v.ai2 >= 40 and eatenplayer ~= 2 or not v.underwater then
			v.speedY = -7.4
			v.ai2 = 0
			v.ai1 = 1
		end
		
		if eatenplayer == 1 then
			v.ai5 = v.ai5 + 1
			if v.ai5 == 15 then
				player:kill()
				for k,w in ipairs(Effect.get({3, 5, 129, 130, 134, 149, 150, 151, 152, 153, 154, 155, 156, 159, 161})) do
					w.timer = 0
					w.animationFrame = -1000
				end
				eatenplayer = false
				eatenplayer = 2
			end
		end
	elseif v.ai1 == 1 then
		v.speedX = 3 * v.direction
		if v.ai2 >= 15 and v.underwater then
			v.ai2 = 0
			v.ai1 = 2
			areamomentum = v.ai4 - v.y / 2
		end
	elseif v.ai1 == 2 then
		if v.underwater then
			watermomentum = v.speedY
			if v.y <= v.ai4 then
				v.ai1 = 3
				v.ai2 = 0
			end
		end
	else
		v.speedY = v.speedY - watermomentum * 1 * Defines.npc_grav;
		if v.y <= v.ai4 and v.ai2 >= 3 then
			v.ai1 = 0
			v.ai2 = 0
		end
	end
	
	--Eating behavior
	if v.ai1 or v.ai2 and eatenplayer == false then
		if Colliders.collide(player, mouthbox) then
			if player.forcedState == 0 and not player:isInvincible() and player.hasStarman == false and player.isMega == false and player.deathTimer == 0 then
				eatenplayer = 1
				eatenx = player.x
				eateny = player.y
			end
		end
	end
	
	if eatenplayer > 0 then
		player.forcedState = 8
		player:mem(0x140, FIELD_WORD, 2)
		player.x = eatenx
		player.y = eateny
	end
end

function sampleNPC.onDrawNPC(v)
	utils.restoreAnimation(v)
	swim = utils.getFrameByFramestyle(v, {
		frames = 2,
		gap = 3,
		offset = 0
	})
	jump = utils.getFrameByFramestyle(v, {
		frames = 2,
		gap = 1,
		offset = 2
	})
	dive = utils.getFrameByFramestyle(v, {
		frames = 1,
		gap = 0,
		offset = 4
	})
	
	if v.ai1 == 0 then
		v.animationFrame = swim
	elseif v.ai1 == 1 or v.ai1 == 2 then
		if eatenplayer == 1 then
			v.animationFrame = swim
		else
			v.animationFrame = jump
		end
	else
		v.animationFrame = dive
	end
end

--Gotta return the library table!
return sampleNPC