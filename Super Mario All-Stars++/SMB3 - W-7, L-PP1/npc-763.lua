--NPCManager is required for setting basic NPC properties
local npcManager = require("npcManager")

--Create the library table
local pipeMuncher = {}
--NPC_ID is dynamic based on the name of the library file
local npcID = NPC_ID

--Defines NPC config for our NPC.
local pipeMuncherSettings = {
	id = npcID,
	gfxheight = 32,
	gfxwidth = 32,
	width = 32,
	height = 32,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 5,
	framestyle = 0,
	framespeed = 8,
	speed = 1,
	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,

	nohurt=false,
	nogravity = false,
	noblockcollision = false,
	nofireball = true,
	noiceball = true,
	noyoshi= true,
	nowaterphysics = false,
	
	jumphurt = true,
	spinjumpsafe = true,
	harmlessgrab = false,
	harmlessthrown = false,

	ignorethrownnpcs = true,
}

--Applies NPC settings
npcManager.setNpcSettings(pipeMuncherSettings)

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

local STATE_HIDE = 0
local STATE_UP = 1
local STATE_SHOW = 2
local STATE_DOWN = 3

local animationTimer = 0
local animationFrame = 0

local delayTimer = 0

local state = STATE_HIDE


--Register events
function pipeMuncher.onInitAPI()
	npcManager.registerEvent(npcID, pipeMuncher, "onTickNPC")
	npcManager.registerEvent(npcID, pipeMuncher, "onDrawNPC")
	--Separate frame counter. All NPC instances shared the same counter
	registerEvent(pipeMuncher, "onTick", "onTickFrameCounter")
end

function pipeMuncher.onTickFrameCounter()
	--If time freeze, freeze the counter too
	if Defines.levelFreeze then return end

	animationTimer = animationTimer+1
	
	if animationTimer==8 then
		animationTimer = 0
		
		if state == STATE_HIDE or state == STATE_SHOW then
			delayTimer = delayTimer+1
			if delayTimer > 8 then
					if state == STATE_HIDE then
						state = STATE_UP
					elseif state == STATE_SHOW then
						state = STATE_DOWN
					end
				delayTimer = 0
			end
		elseif state == STATE_UP then
			animationFrame = animationFrame+1
			if animationFrame>=4 then
				state = STATE_SHOW
			end
		elseif state == STATE_DOWN then
			animationFrame = animationFrame-1
			if animationFrame<=0 then
				state = STATE_HIDE
			end
		end
		
	end
end

function pipeMuncher.onTickNPC(v)
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
	end

	--Depending on the NPC, these checks must be handled differently
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		--Handling
	end

	--Execute main AI.
	if v.animationFrame==4 then
			v.friendly = false
	else
			v.friendly = true
	end
end

function pipeMuncher.onDrawNPC(v)
	
	if v:mem(0x12A, FIELD_WORD) <= 0 then return end

	local frame = animationFrame
	
	if v.direction==-1 then
		v.animationFrame = frame
	else
		v.animationFrame = 4-frame
	end

end

--Gotta return the library table!
return pipeMuncher