--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")

--NPCutils for rendering
local npcutils = require("npcs/npcutils")

--Create the library table
local QuadCannon = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local QuadSettings = {
	id = npcID,
	--Sprite size
	gfxheight = 64,
	gfxwidth = 64,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 64,
	height = 64,
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
	noyoshi= false,
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
local quadConfig = npcManager.setNpcSettings(QuadSettings)

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
function QuadCannon.onInitAPI()
	npcManager.registerEvent(npcID, QuadCannon, "onTickNPC")
	--npcManager.registerEvent(npcID, QuadCannon, "onTickEndNPC")
	npcManager.registerEvent(npcID, QuadCannon, "onDrawNPC")
	--registerEvent(QuadCannon, "onNPCKill")
end

function QuadCannon.onTickNPC(v)
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
	
	-- Data Variables --
	data.hasShot = data.hasShot or false
	data.shootingAngle = data.shootingAngle or 0
	data.angle = math.min((data.angle or 0) + 1.5, data.shootingAngle)
	data.vAngle = vector(0, -1):rotate(data.shootingAngle)

	-- Centered coords --
	local rx = v.x+v.width/2
	local ry = v.y+v.height/2

	--Execute main AI --
	data.shootTimer = data.shootTimer or lunatime.toTicks(0.4)
	if data.shootingAngle == data.angle and not v.friendly then
		data.shootTimer = data.shootTimer - 1
		if data.shootTimer <= 0 then
			if not data.hasShot then
				for n=-1, 1, 2 do
					local v1 = NPC.spawn(QuadSettings.projectileid, rx+(data.vAngle.x*v.width/3*n), ry+(data.vAngle.y*v.height/3*n), v.section, false, true)
					v1.speedX, v1.speedY = data.vAngle.x * 2 * n, data.vAngle.y * 2 * n
					a1 = Animation.spawn(131, v1.x+(data.vAngle.x*24*n), v1.y+(data.vAngle.y*24*n))
					v1.direction = -1
				end
				SFX.play(22)
				data.hasShot = true
				data.shootTimer = lunatime.toTicks(0.5)
			else
				if data.shootingAngle >= 360 then
					data.shootingAngle = 45
					data.angle = 0
				else
					data.shootingAngle = data.shootingAngle + 45
				end
				data.hasShot = false
				data.shootTimer = lunatime.toTicks(0.5)
			end
		end
	end

	-- Layer Movement --
	npcutils.applyLayerMovement(v)
end

function QuadCannon.onDrawNPC(v)
	-- Data stuff --
	local data = v.data

	if not data.initialized or v:mem(0x40, FIELD_BOOL) then return end

	-- Creating the sprite --
	data.img = data.img or Sprite{x = 0, y = 0, pivot = vector(0.5, 0.5), frames = 1, texture = Graphics.sprites.npc[v.id].img}

	-- Sprite properties --
	data.img.x, data.img.y = v.x+v.width/2, v.y+v.height/2
	data.img.rotation = data.angle
	if data.img.rotation >= 360 then data.img.rotation = 0 end

	-- Drawing --
	data.img:draw{sceneCoords = true, priority = -45}

	npcutils.hideNPC(v)
end

--Gotta return the library table!
return QuadCannon