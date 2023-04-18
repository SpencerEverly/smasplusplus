--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")
local imagic = require("imagic")
local utils = require("npcs/npcutils")
local playerStun = require("playerstun")
local smasExtraSounds = require("smasExtraSounds")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
	id = npcID,
	--Sprite size
	gfxwidth = 84,
	gfxheight = 80,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 48,
	height = 48,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = -18,
	gfxoffsety = 16,
	--Frameloop-related
	frames = 6,
	framestyle = 1,
	framespeed = 8, --# frames between frame change
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
	
	health = 5,
	stunframes = 70,

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
		HARM_TYPE_JUMP,
		--HARM_TYPE_FROMBELOW,
		HARM_TYPE_NPC,
		--HARM_TYPE_PROJECTILE_USED,
		HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
		--HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD
	}, 
	{
		--[HARM_TYPE_JUMP]=10,
		--[HARM_TYPE_FROMBELOW]=10,
		--[HARM_TYPE_NPC]=10,
		--[HARM_TYPE_PROJECTILE_USED]=10,
		[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		--[HARM_TYPE_HELD]=10,
		--[HARM_TYPE_TAIL]=10,
		--[HARM_TYPE_SPINJUMP]=10,
		[HARM_TYPE_OFFSCREEN]={id=10, xoffset=0.45, yoffset=.9}
		--[HARM_TYPE_SWORD]=10,
	}
);

--Custom local definitions below
local smwbossdefeat = smasExtraSounds.sounds[129].sfx
local smwbosspoof = smasExtraSounds.sounds[130].sfx

--Register events
function sampleNPC.onInitAPI()
	npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
	--npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
	npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
	registerEvent(sampleNPC, "onNPCHarm", "onNPCHarm", false)
end

function sampleNPC.onTickEndNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data
	v.isonCeiling = 0
	
	--If despawned
	if v.despawnTimer <= 0 then
		--Reset our properties, if necessary
		data.initialized = false
		return
	end

	--Initialize
	if not data.initialized then
		--Initialize necessary data.
		v.ai1 = 0
		v.ai2 = 0
		v.health = sampleNPCSettings.health
		v.rotation = 0
		v.isonCeiling = 0
		v.isonWall = false
		v.directionalAnimation = 0
		v.ai3 = 0
		v.ai4 = 0
		v.hitspeed = 3
		
		data.initialized = true
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end
	
	v.hitspeed = 3 + ((sampleNPCSettings.health - v.health) / 4)
	
	--Execute main AI. This template just jumps when it touches the ground.
	if v.direction == -1 then
		v.directionalAnimation = 0
	else
		v.directionalAnimation = sampleNPCSettings.frames
	end
	
	if v.ai1 < 6 then
		if v.animationFrame == 3 + v.directionalAnimation then
			v.animationFrame = 0 + v.directionalAnimation
		end
	end
	
	if v.ai1 < 9 and v.health < 0 then
		v.ai1 = 99
		SFX.play(39)
	end
	
	if v.ai1 == 0 then --Walking on the ground
		v.speedX = v.hitspeed * v.direction
		if v.collidesBlockLeft or v.collidesBlockRight and v.collidesBlockBottom then
			v.ai1 = 1
		end
	elseif v.ai1 == 1 then --Turning to walk up the wall
		v.speedX = 0
		v.rotation = v.rotation - (v.hitspeed * v.direction)
		if (v.rotation >= 90 and v.direction == -1) or (v.rotation <= -90 and v.direction == 1) then
			v.ai1 = 2
			v.rotation = -90 * v.direction
		end
	elseif v.ai1 == 2 then --Walking up the wall
		v.ai2 = v.ai2 + 1
		v.speedY = -v.hitspeed
		if v.collidesBlockUp then
			v.ai1 = 3
		end
		
		if v.ai2 == 3 then
			v.isonWall = false
			v.ai2 = 0
		end
		
		if v.direction == 1 then
			for s,b in ipairs(Block.getIntersecting(v.x + v.width + 8, v.y + v.height, v.x + v.width + 4, v.y + v.height)) do
				v.isonWall = true
				Text.print(isValid, 100, 164)
				if not Block.SOLID_MAP[b.id] then
					v.ai1 = 5
					v.x = v.x + (4 * v.direction)
				end
			end
		end
		if v.direction == -1 then
			for s,b in ipairs(Block.getIntersecting(v.x - 4, v.y + v.height, v.x, v.y + v.height)) do
				v.isonWall = true
				Text.print(isValid, 100, 164)
				if not Block.SOLID_MAP[b.id] then
					v.ai1 = 7
					v.x = v.x + (4 * v.direction)
				end
			end
		end
		
		if v.isonWall == false then
			v.ai1 = 5
			v.ai2 = 0
			v.x = v.x + (4 * v.direction)
		end
	elseif v.ai1 == 3 then --Turning to walk on the ceiling
		v.ai2 = 0
		v.speedX = 0
		v.speedY = -3
		v.rotation = v.rotation - (v.hitspeed * v.direction)
		if (v.rotation >= 180 and v.direction == -1) or (v.rotation <= -180 and v.direction == 1)then
			v.ai1 = 4
			v.rotation = -180 * v.direction
		end
	elseif v.ai1 == 4 then --Walking on the ceiling
		v.isonCeiling = 2
		v.speedX = -v.hitspeed * v.direction
		v.speedY = v.speedY - 1
		if v.collidesBlockUp then
			v.y = v.y + 3
			v.speedY = 0
		end
		if (player.x > v.x + (v.width / 2 - 12) and player.x < v.x + (v.width / 2 - 3)) or v.speedY < -3 then
			v.ai1 = 6
		end
	elseif v.ai1 == 5 then --Getting off of a wall if it ends before a ceiling
		v.speedX = 0
		v.speedY = 0
		v.rotation = v.rotation + (v.hitspeed * v.direction)
		if (v.rotation <= 0 and v.direction == -1) or (v.rotation >= 0 and v.direction == 1) then
			v.ai1 = 0
			v.rotation = 0 * v.direction
		end
	elseif v.ai1 == 6 then --Falling onto the player
		v.isonCeiling = 0
		v.speedX = 0
		v.speedY = v.speedY + 3
		v.animationFrame = 5 + v.directionalAnimation
		if v.rotation ~= 0 then
			v.rotation = v.rotation + (7.5 * v.direction)
		end
		if v.collidesBlockBottom then
			v.ai1 = 7
			SFX.play(37)
			for k, p in ipairs(Player.get()) do --Section copypasted from the Sledge Bros. code
				if p:isGroundTouching() and not playerStun.isStunned(k) and v:mem(0x146, FIELD_WORD) == player.section then
					playerStun.stunPlayer(k, sampleNPCSettings.stunframes)
				end
			end
		end
	elseif v.ai1 == 7 then --Landed on the ground after falling on the player
		v.rotation = 0
		v.ai2 = v.ai2 + 1
		if v.ai2 < 26 then
			v.animationFrame = 5 + v.directionalAnimation
		elseif v.ai2 == 39 then
			v.animationFrame = 0 + v.directionalAnimation
		elseif v.ai2 == 40 then
			v.ai2 = 0
			v.ai1 = 0
		else
			v.animationFrame = 4 + v.directionalAnimation
			if v.x < player.x then
				v.direction = 1
			else
				v.direction = -1
			end
		end
	elseif v.ai1 == 8 then
		v.speedX = 0
		v.ai2 = v.ai2 + 1
		v.animationFrame = 5 + v.directionalAnimation
		v.friendly = true
		if v.ai2 < 40 then
			v.ai3 = 48
			v.ai4 = 40
		elseif v.ai2 >= 40 then
			if v.ai3 > 0 then
				v.ai3 = v.ai3 - 3
			else
				v.ai3 = 0
			end
			if v.ai4 > 0 then
				v.ai4 = v.ai4 - 3
			else
				v.ai4 = 0
			end
		end
		
		if v.ai2 == 80 then
			v.friendly = false
			v.ai2 = 30
			v.ai1 = 7
		end
	else
		v.friendly = true
		v.speedX = 0
		v.speedY = -v.speedY - .27
		v.ai2 = v.ai2 + 1
		v.animationFrame = 5 + v.directionalAnimation
		v.noblockcollision = true
		if v.ai2 < 40 then
			v.ai3 = 48
			v.ai4 = 40
		elseif v.ai2 == 49 then
			SFX.play(smwbossdefeat)
		elseif v.ai2 >= 50 and v.ai2 < 80 then
			v.ai3 = v.ai3 + 6
			v.ai4 = v.ai4 - 4
			v.y = v.y - 3
		elseif v.ai2 >= 80 then
			v.rotation = v.rotation + 3
			v.ai3 = v.ai3 - 1.8
			v.ai4 = v.ai4 + .90
			if v.ai2 == 250 then
				v:kill(HARM_TYPE_OFFSCREEN)
				SFX.play(smwbosspoof)
			end
		end
	end
end

function sampleNPC.onDrawNPC(v)
	if v.despawnTimer <= 0 then return end
	
	--Text.print(v.ai1, 100, 100)
	--Text.print(v.speedX, 100, 116)
	--Text.print(v.ai2, 100, 132)
	
	imagic.Draw{
		texture = Graphics.sprites.npc[v.id].img,
		sourceWidth = sampleNPCSettings.gfxwidth,
		sourceHeight = sampleNPCSettings.gfxheight,
		sourceY = v.animationFrame * sampleNPCSettings.gfxheight,
		scene = true,
		x = v.x + sampleNPCSettings.gfxoffsetx + sampleNPCSettings.gfxwidth * 0.5 + (3 * v.direction),
		y = v.y - sampleNPCSettings.gfxoffsety + sampleNPCSettings.gfxheight * 0.5 + (v.ai4 / 3.4) - v.isonCeiling,
		rotation = v.rotation,
		width = sampleNPCSettings.gfxwidth + v.ai3,
		height = sampleNPCSettings.gfxheight - v.ai4,
		align = imagic.ALIGN_CENTRE,
		priority = -45
	}
	utils.hideNPC(v)
end

function sampleNPC.onNPCHarm(eventObj, v, killReason, culprit)
	if npcID ~= v.id or v.isGenerator then return end

	if killReason ~= HARM_TYPE_LAVA then
		eventObj.cancelled = true
		if v.ai1 == 0 then
			if killReason == HARM_TYPE_JUMP or killReason == HARM_TYPE_SPINJUMP then
				SFX.play(2)
				SFX.play(39)
				v.ai1 = 8
				v.ai2 = 0
				v.health = v.health - 1.7
			else
				v.health = v.health - 1
			end
		end
	end
end

--Gotta return the library table!
return sampleNPC