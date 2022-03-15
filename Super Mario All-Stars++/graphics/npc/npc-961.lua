--[[

	See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")

local projectile = {}
local npcID = NPC_ID

local projectileSettings = {
	id = npcID,
	
	gfxwidth = 16,
	gfxheight = 16,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 16,
	height = 16,
	
	frames = 1,
	framestyle = 0,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt = true,
	nogravity = true,
	noblockcollision = true,
	nofireball = true,
	noiceball = true,
	noyoshi = true,
	nowaterphysics = true,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	ignorethrownnpcs = true,
}

npcManager.setNpcSettings(projectileSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})


function projectile.onInitAPI()
	npcManager.registerEvent(npcID, projectile, "onTickNPC")
end


local function kill(v)
	local e = Effect.spawn(74, v.x + v.width*0.5,v.y + v.height*0.5)

	e.x = e.x - e.width *0.5
	e.y = e.y - e.height*0.5

	v:kill(HARM_TYPE_VANISH)
end


function projectile.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v.despawnTimer <= 0 then
		data.initialized = false
		return
	end

	local config = NPC.config[v.id]

	if not data.initialized then
		data.initialized = true
		
		data.oldX = v.x
	end

	-- Prevent screen wrapping
	local b = v.sectionObj.boundary

	if v.sectionObj.wrapH and ((v.x+v.width >= b.right and data.oldX <= b.left) or (v.x <= b.left or data.oldX+v.width >= b.right)) then
		v:kill(HARM_TYPE_VANISH)
	end

	data.oldX = v.x


	local npcs = Colliders.getColliding{a = v,b = NPC.HITTABLE,btype = Colliders.NPC}

	for _,npc in ipairs(npcs) do
		if npc:mem(0x138,FIELD_WORD) == 0 and npc:mem(0x12C,FIELD_WORD) == 0 then
			npc:harm(HARM_TYPE_NPC)

			if npc:mem(0x122,FIELD_WORD) > 0 or npc:mem(0x156,FIELD_WORD) > 0 then
				kill(v)
			end
		end
	end

	v:mem(0x12E,FIELD_BOOL,true)
end

return projectile