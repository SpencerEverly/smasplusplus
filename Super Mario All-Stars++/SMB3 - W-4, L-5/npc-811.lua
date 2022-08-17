--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")

--Create the library table
local sampleNPC = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC. You can remove superfluous definitions.
local sampleNPCSettings = {
	id = npcID,
	--Sprite size
	gfxheight = 28,
	gfxwidth = 32,
	--Hitbox size. Bottom-center-bound to sprite size.
	width = 32,
	height = 28,
	--Sprite offset from hitbox for adjusting hitbox anchor on sprite.
	gfxoffsetx = 0,
	gfxoffsety = 0,
	--Frameloop-related
	frames = 3,
	framestyle = 1,
	framespeed = 4, --# frames between frame change
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
	nofireball = true,
	noiceball = false,
	noyoshi= false,
	nowaterphysics = false,
	--Various interactions
	jumphurt = false, --If true, spiny-like
	spinjumpsafe = false, --If true, prevents player hurt when spinjumping
	harmlessgrab = false, --Held NPC hurts other NPCs if false
	harmlessthrown = false, --Thrown NPC hurts other NPCs if false

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
		HARM_TYPE_PROJECTILE_USED,
		--HARM_TYPE_LAVA,
		HARM_TYPE_HELD,
		HARM_TYPE_TAIL,
		HARM_TYPE_SPINJUMP,
		--HARM_TYPE_OFFSCREEN,
		HARM_TYPE_SWORD
	}, 
	{
		[HARM_TYPE_JUMP]={id=810, speedX = 0, speedY = 0},
		--[HARM_TYPE_FROMBELOW]=10,
		[HARM_TYPE_NPC]=810,
		[HARM_TYPE_PROJECTILE_USED]=810,
		--[HARM_TYPE_LAVA]={id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5},
		[HARM_TYPE_HELD]=810,
		[HARM_TYPE_TAIL]=810,
		[HARM_TYPE_SPINJUMP]=810,
		--[HARM_TYPE_OFFSCREEN]=10,
		--[HARM_TYPE_SWORD]=10,
	}
);

--Custom local definitions below


--Register events
function sampleNPC.onInitAPI()
	npcManager.registerEvent(npcID, sampleNPC, "onTickNPC")
	npcManager.registerEvent(npcID, sampleNPC, "onTickEndNPC")
	--npcManager.registerEvent(npcID, sampleNPC, "onDrawNPC")
	--registerEvent(sampleNPC, "onNPCKill")
end

local function getDistance(k,p)
	return k.x - p.x, k.x < p.x
end

local function setDir(dir, v)
	if (dir and v.data._basegame.direction == 1) or (v.data._basegame.direction == -1 and not dir) then return end
	if dir then
		v.data._basegame.direction = 1
	else
		v.data._basegame.direction = -1
	end
end

local function chasePlayers(v)
	if Player.count() == 2 then --Change to Player.count() as it's more reliable and prevents errors
		local p1, dir1 = getDistance(v, player)
		local p2, dir2 = getDistance(v, player2)
		if p1 > p2 then
			setDir(dir2, v)
		else
			setDir(dir1, v)
		end
    elseif Player.count() >= 3 then --Just get the first player if more than 2 players, don't wanna give spam spagetti everywhere
        local p1, dir1 = getDistance(v, player)
		setDir(dir1, v)
	else
		local p1, dir1 = getDistance(v, player)
		setDir(dir1, v)
	end
end

local firstTick = true

function sampleNPC.onTickNPC(v)
	--Don't act during time freeze
	if Defines.levelFreeze then return end
	
	local data = v.data._basegame
	
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
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end

	if data.direction == nil then
		data.direction = -1
	end
	
	if data.turnamount == nil then
		data.turnamount = 0
	end
	
	--Execute main AI. This template just jumps when it touches the ground.
	if not (v:mem(0x12C, FIELD_WORD) > 0 or v:mem(0x132, FIELD_WORD) > 0 or v:mem(0x134, FIELD_WORD) > 0) then --chase
		if data.turnamount ~= 3 then
			chasePlayers(v)
		end
		v.speedX = math.clamp(v.speedX + 0.075 * data.direction, -4, 4)
	else
		local pN = v:mem(0x12C, FIELD_WORD)
		if pN == 0 then
			pN = v:mem(0x132, FIELD_WORD)
		end
		if pN ~= 0 then
			data.direction = Player(pN).direction
		end
	end
	if v.speedX <= .01 and v.direction == 1 then
		data.turnamount = data.turnamount + 1
	else if v.speedX >= -.01 and v.direction == -1 then
		data.turnamount = data.turnamount + 1
	end
	end
end
--Gotta return the library table!
return sampleNPC