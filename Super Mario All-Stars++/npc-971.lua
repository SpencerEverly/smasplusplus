--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local playerManager = require("playerManager")
--Create the library table
local smb1Blooper = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local config = {
	id = npcID,
	--Sprite size
	gfxheight = 48,
	gfxwidth = 32,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 64,
	height = 32,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 16,
	--Frameloop-related
	frames = 2,
	framestyle = 0,
	framespeed = 8, --# frames between frame change
	--Movement speed. Only affects speedX by default.
	speed = 1,
	--Collision-related
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt=false,
	nogravity = false,
	noblockcollision = false,
	nofireball = false,
	noiceball = false,
	noyoshi= false,
	nowaterphysics = true,
	--Various interactions
	jumphurt = true, --If true, spiny-like
	spinjumpsafe = false, --If true, prevents player hurt when spinjumping
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
	aquatic = false
}

--Applies NPC settings
npcManager.setNpcSettings(config)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		--HARM_TYPE_JUMP,
		--HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		HARM_TYPE_PROJECTILE_USED,
		--HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
		HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD
	}, 
	{
		--[HARM_TYPE_JUMP]=920,
		--[HARM_TYPE_FROMBELOW]=10,
		[HARM_TYPE_NPC]=997,
		[HARM_TYPE_PROJECTILE_USED]=997,
		--[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]=997,
		[HARM_TYPE_TAIL]=997,
		[HARM_TYPE_SPINJUMP]=10,
		--[HARM_TYPE_OFFSCREEN]=920,
		[HARM_TYPE_SWORD]=70,
	}
);

--Custom local definitions below
--Register events
function smb1Blooper.register(id)
	--npcManager.registerEvent(npcID, smb1Blooper, "onTickNPC")
	npcManager.registerEvent(id, smb1Blooper, "onTickEndNPC")
	--npcManager.registerEvent(npcID, smb1Blooper, "onDrawNPC")
	--registerEvent(smb1Blooper, "onNPCKill")
end

function smb1Blooper.onTickEndNPC(v)
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
		data.initialized = true
		data.blooperstate = 1 --1 = sinking, 2 = floating, 3 = beached
		data.noticetimer = 0 --Set to 50
		data.noticecooldown = 0 --set to 5
		data.determinedirection = 0
		data.aquatic = data._settings.aquatic
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	local settings = PlayerSettings.get(playerManager.getBaseID(player.character),player.powerup)
	
	v.animationTimer = 0
	if data.aquatic == true and v.underwater == false then
		data.blooperstate = 3
	elseif data.blooperstate == 3 and v.underwater == true then
		data.blooperstate = 1
		data.noticecooldown = 20
	end
	if data.noticecooldown == 0 and player.y - settings.hitboxDuckHeight < v.y and data.blooperstate ~= 3 then
		data.blooperstate = 2
		data.noticetimer = 50
		if player.x > v.x then
			v.direction = 1
		else
			v.direction = -1
		end
		data.determinedirection = math.random(1, 5)
		if data.determinedirection == 5 then
			v.direction = v.direction * -1
		end
	end
	if data.blooperstate == 1 then
		v.animationFrame = 1
		v.speedX = 0
		v.speedY = 1
	elseif data.blooperstate == 2 then
		v.animationFrame = 0
		data.noticecooldown = 2
		v.speedX = data.noticetimer * .105 * v.direction
		v.speedY = data.noticetimer * -.105 - 1
		if data.noticetimer <= 0 or v.collidesBlockUp then
			data.noticetimer = 0
			data.blooperstate = 1
			data.noticecooldown = 20
		end
	else
		v.speedY = Defines.gravity
		if v.collidesBlockBottom then
			v.speedX = 0
		end
	end
	
	if data.noticetimer > 0 then
		data.noticetimer = data.noticetimer - 2
	end
	if data.noticecooldown > 0 then
		data.noticecooldown = data.noticecooldown - 1
	end
end

--Gotta return the library table!
return smb1Blooper