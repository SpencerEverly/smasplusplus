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
	gfxwidth = 48,
	gfxheight = 64,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 48,
	height = 64,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 0,
	--Frameloop-related
	frames = 4,
	framestyle = 1,
	framespeed = 8, --# frames between frame change
	--Movement speed. Only affects speedX by default.
	speed = 1,
	--Collision-related
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt=false,
	nogravity = true,
	noblockcollision = true,
	nofireball = false,
	noiceball = false,
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
		--HARM_TYPE_PROJECTILE_USED,
		--HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
		--HARM_TYPE_TAIL,
		--HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD
	}, 
	{
		--[HARM_TYPE_JUMP]=10,
		--[HARM_TYPE_FROMBELOW]=10,
		[HARM_TYPE_NPC]=870,
		--[HARM_TYPE_PROJECTILE_USED]=10,
		--[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]=870,
		--[HARM_TYPE_TAIL]=10,
		--[HARM_TYPE_SPINJUMP]=10,
		--[HARM_TYPE_OFFSCREEN]=10,
		--[HARM_TYPE_SWORD]=10,
	}
);

--Custom local definitions below


--Register events
function sampleNPC.onInitAPI()
	npcManager.registerEvent(npcID, sampleNPC, "onTickNPC")
	--npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
	npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
	--registerEvent(sampleNPC, "onNPCKill")
end

function sampleNPC.onTickNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	
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
		v.ai1 = 0
		v.ai2 = v.direction
		v.ai3 = 0
		v.ai4 = 1
		v.ai5 = 0
		v.storedSpeed = v.speedX
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	
	--Execute main AI. This template just jumps when it touches the ground.
	--Text.print(v.speedY, 100, 100)
	
	v.speedY = math.clamp(v.speedY + (.05 * v.ai4), -2, 2)
	if v.speedY >= 1 or v.speedY <= -1 then
		v.ai4 = -v.ai4
	end
	
	v.ai5 = v.ai5 + 1
	
	if v.ai1 ~= 1 then
		v.speedX = math.clamp(v.speedX + (.07 * v.ai2), -4, 4)
		
		v.ai3 = v.ai3 + 1
		if v.ai3 == 75 then
			v.ai3 = -75
			v.ai2 = v.ai2 * -1
		end
		
		if v.ai1 == 0 then
			if v.ai5 == 140 then
				v.ai1 = 1
				v.ai5 = 0
				v.storedSpeed = v.speedX
			end
		else
			if Colliders.collide(v, babyCheep)	then
				v.ai1 = 0
				v.ai5 = 25
				babyCheep:kill(HARM_TYPE_OFFSCREEN)
			elseif v.ai5 == 150 then
				v.ai1 = 0
				v.ai5 = 0
			end
		end
	else
		v.speedX = 0
		v.ai5 = v.ai5 + 1
		if v.ai5 == 50 then
			babyCheep = NPC.spawn(871, v.x + (v.width / 4), v.y + (v.height / 2) - 2)
			babyCheep.direction = v.direction
		elseif v.ai5 >= 100 then
			v.ai1 = 2
			v.ai5 = 0
			v.speedX = v.storedSpeed
		end
	end
end

function sampleNPC.onDrawNPC(v)
	if v.despawnTimer <= 0 then
		return
	end
	
	closed = utils.getFrameByFramestyle(v, {
		frames = 2,
		gap = 2,
		offset = 0
	})
	open = utils.getFrameByFramestyle(v, {
		frames = 2,
		gap = 0,
		offset = 2
	})
	
	if v.ai1 == 0 then
		v.animationFrame = closed
	else
		v.animationFrame = open
	end
	
	utils.drawNPC(v, {priority = -44})
	utils.hideNPC(v)
end

--Gotta return the library table!
return sampleNPC