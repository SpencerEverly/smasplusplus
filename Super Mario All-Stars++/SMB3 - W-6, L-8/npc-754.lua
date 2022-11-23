--[[

	Written by MrDoubleA
	Please give credit!

	Credit to Saturnyoshi for starting to make "newplants" and creating most of the graphics used

	Part of MrDoubleA's NPC Pack

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")

local fireball = {}
local npcID = NPC_ID

local fireballSettings = {
	id = npcID,
	
	gfxwidth = 16,
	gfxheight = 16,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 16,
	height = 16,
	
	frames = 4,
	framestyle = 0,
	framespeed = 4,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt = false,
	nogravity = true,
	noblockcollision = true,
	nofireball = false,
	noiceball = false,
	noyoshi = true,
	nowaterphysics = false,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	ignorethrownnpcs = true,
}

npcManager.setNpcSettings(fireballSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})


local function homeIn(v,playerObj)
	-- I don't know why redigit did it like this but this is a recreation of the original code
	local config = NPC.config[v.id]

	local distance = vector(
		(playerObj.x+(playerObj.width /2))-(v.x+(v.width /2)),
		(playerObj.y+(playerObj.height/2))-(v.y+(v.height/2))
	)


	v.speedX = 3*math.sign(distance.x)
	v.speedY = math.clamp((distance:normalise().y)*3,-2,2)*config.speed
end


function fireball.onInitAPI()
	npcManager.registerEvent(npcID,fireball,"onTickNPC")
end

function fireball.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v.despawnTimer <= 0 then
		data.hasStartedHoming = nil
		return
	end

	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then return end
	
	if not data.hasStartedHoming then
		local playerObj = npcutils.getNearestPlayer(v)

		if playerObj ~= nil then
			data.hasStartedHoming = true
			homeIn(v,playerObj)
		end
	end
end


return fireball