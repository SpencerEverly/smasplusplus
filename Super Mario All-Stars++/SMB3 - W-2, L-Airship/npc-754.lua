--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")

--NPCutils for rendering
local npcutils = require("npcs/npcutils")

--Create the library table
local dirCannon = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local dirCannonSettings = {
	id = npcID,
	--Sprite size
	gfxheight = 32,
	gfxwidth = 32,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 32,
	height = 32,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 0,
	--Frameloop-related
	frames = 1,
	framestyle = 0,
	framespeed = 8, --# frames between frame change
	--Movement speed. Only affects speedX by default.
	speed = 1,
	--Collision-related
	npcblock = true,
	npcblocktop = true, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = true,
	playerblocktop = true, --Also handles other NPCs walking atop this NPC.

	nohurt=true,
	nogravity = true,
	noblockcollision = false,
	nofireball = false,
	noiceball = false,
	noyoshi= true,
	nowaterphysics = false,
	--Various interactions
	jumphurt = false, --If true, spiny-like
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
	projectileid=752
}

--Applies NPC settings
local cannonSettings = npcManager.setNpcSettings(dirCannonSettings)

--Register the vulnerable harm types for this NPC. The first table defines the harm types the NPC should be affected by, while the second maps an effect to each, if desired.
npcManager.registerHarmTypes(npcID,
	{
		--HARM_TYPE_JUMP,
		--HARM_TYPE_FROMBELOW,
		--HARM_TYPE_NPC,
		--HARM_TYPE_PROJECTILE_USED,
		--HARM_TYPE_LAVA,
		--HARM_TYPE_HELD,
		--HARM_TYPE_TAIL,
		--HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		--HARM_TYPE_SWORD
	}, 
	{
		--[HARM_TYPE_JUMP]=10,
		--[HARM_TYPE_FROMBELOW]=10,
		--[HARM_TYPE_NPC]=10,
		--[HARM_TYPE_PROJECTILE_USED]=10,
		--[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		--[HARM_TYPE_HELD]=10,
		--[HARM_TYPE_TAIL]=10,
		--[HARM_TYPE_SPINJUMP]=10,
		--[HARM_TYPE_OFFSCREEN]=10,
		--[HARM_TYPE_SWORD]=10,
	}
);

--Custom local definitions below

--Register events
function dirCannon.onInitAPI()
	npcManager.registerEvent(npcID, dirCannon, "onTickNPC")
	--npcManager.registerEvent(npcID, dirCannon, "onTickEndNPC")
	npcManager.registerEvent(npcID, dirCannon, "onDrawNPC")
	--registerEvent(dirCannon, "onNPCKill")
end

local function booltoNumber(bool)
	if bool then return 1 else return 0 end
end

function dirCannon.onTickNPC(v)
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
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		return
	end
	
	-- Custom settings --
	local cfg = data._settings

	-- Defining some data variables --
	data.shootTimer = data.shootTimer or lunatime.toTicks(cfg.aOptions.roundDelay)
	data.shotsFired = data.shotsFired or 0
	data.sprSize = math.max(data.sprSize or 1, 1) or 1
	data.sprSize = data.sprSize - 0.05
	data.angle = data.angle or cfg.bOptions.shootAngle
	if data.angle > 360 then
		data.angle = data.angle - 360
	end

	-- Calculating angles in vectors and center of NPC --
	data.vAngle = vector(0, -1):rotate(data.angle)
	data.NPCenter = vector(v.x + v.width/2, v.y + v.height/2)

	-- Handling shooting --
	data.shootTimer = data.shootTimer - 1
	if not v.friendly then
		if data.shootTimer <= 0 then
			v1 = NPC.spawn(cannonSettings.projectileid, data.NPCenter.x + (data.vAngle.x * v.width/3), data.NPCenter.y + (data.vAngle.y * v.height/3), v.section, false, true)
			v1.speedX, v1.speedY = data.vAngle.x * cfg.bOptions.shootSpeed, data.vAngle.y * cfg.bOptions.shootSpeed
			v1.direction = -1 + (booltoNumber(cfg.aOptions.pAim) * 2)
			a1 = Animation.spawn(131, v1.x + (data.vAngle.x * 16), v1.y + ((data.vAngle.y * 16)))
			if data.shotsFired >= cfg.aOptions.shotsPerRound - 1 then
				data.shootTimer = lunatime.toTicks(cfg.aOptions.roundDelay)
				data.shotsFired = 0
			else
				data.shootTimer = lunatime.toTicks(cfg.aOptions.shootDelay)
				data.shotsFired = data.shotsFired + 1
			end
			SFX.play(22)
			data.sprSize = 1.5
		end
	end

	-- Aiming and Constant Rotation --
	if cfg.aOptions.pAim then
		local cPlayer = Player.getNearest(data.NPCenter.x, data.NPCenter.y)
		data.chVector = vector((cPlayer.x+cPlayer.width/2) - (data.NPCenter.x), (cPlayer.y+cPlayer.height/2) - (data.NPCenter.y)) -- Thanks 8luestorm for this chunk lol
		data.angle = math.deg(math.atan2(data.chVector.y, data.chVector.x)) + 90
	else
		data.angle = data.angle + cfg.aOptions.constantRotation
	end

	-- Layer Movement --
	npcutils.applyLayerMovement(v)
end

function dirCannon.onDrawNPC(v)
	local data = v.data

	if not data.NPCenter or not data._settings.aOptions or v:mem(0x40, FIELD_BOOL) then return end

	-- Accessing custom settings --
	local cfg = data._settings

	-- Creating the sprite --
	data.img = data.img or Sprite{x = 0, y = 0, pivot = vector(0.5, 0.5), frames = 2, texture = Graphics.sprites.npc[v.id].img}

	-- Setting some properties --
	data.img.x, data.img.y = data.NPCenter.x, data.NPCenter.y
	data.img.transform.scale = vector(data.sprSize, data.sprSize)
	data.img.rotation = data.angle

	-- Drawing --
	data.img:draw{frame = 1 + booltoNumber(cfg.aOptions.pAim), sceneCoords = true, priority = -45}

	npcutils.hideNPC(v)
end

--Gotta return the library table!
return dirCannon