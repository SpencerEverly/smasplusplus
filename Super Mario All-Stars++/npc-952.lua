--[[

	See yiYoshi.lua for credits

]]

local npcManager = require("npcManager")
local npcutils = require("npcs/npcutils")


local spitPodoboo = {}
local npcID = NPC_ID

local spitPodobooSettings = {
	id = npcID,
	
	gfxwidth = 32,
	gfxheight = 32,

	gfxoffsetx = 0,
	gfxoffsety = 0,
	
	width = 32,
	height = 32,
	
	frames = 2,
	framestyle = 0,
	framespeed = 8,
	
	speed = 1,
	
	npcblock = false,
	npcblocktop = false, --Misnomer, affects whether thrown NPCs bounce off the NPC.
	playerblock = false,
	playerblocktop = false, --Also handles other NPCs walking atop this NPC.

	nohurt = true,
	nogravity = false,
	noblockcollision = true,
	nofireball = true,
	noiceball = true,
	noyoshi = false,
	nowaterphysics = false,
	
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = false,

	
	ishot = true,
	durability = -1,
}

npcManager.setNpcSettings(spitPodobooSettings)
npcManager.registerHarmTypes(npcID,{HARM_TYPE_OFFSCREEN},{})


function spitPodoboo.onInitAPI()
	npcManager.registerEvent(npcID, spitPodoboo, "onTickNPC")
	npcManager.registerEvent(npcID, spitPodoboo, "onDrawNPC")
end

function spitPodoboo.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	if v.despawnTimer <= 0 then
		return
	end

	local data = v.data

	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		data.rotation = 0
		return
	end

	data.rotation = math.deg(math.atan2(v.speedY,v.speedX))+90
	
	v:mem(0x136,FIELD_BOOL,false)

	-- Hurt NPCs
	local npcs = Colliders.getColliding{a = v,b = NPC.HITTABLE,btype = Colliders.NPC}

	for _,npc in ipairs(npcs) do
		if npc ~= v then
			npc:harm(HARM_TYPE_NPC)
		end
	end

	v:mem(0x120,FIELD_BOOL,false)
end


function spitPodoboo.onDrawNPC(v)
	if v.despawnTimer <= 0 or v.isHidden or v:mem(0x138,FIELD_WORD) > 0 then return end

	local config = NPC.config[v.id]
	local data = v.data

	if data.sprite == nil then
		data.sprite = Sprite{texture = Graphics.sprites.npc[v.id].img,frames = npcutils.getTotalFramesByFramestyle(v),pivot = Sprite.align.CENTRE}
	end

	data.sprite.x = v.x + v.width*0.5 + config.gfxoffsetx
	data.sprite.y = v.y + v.height - config.gfxheight*0.5 + config.gfxoffsety
	data.sprite.rotation = data.rotation or 0

	data.sprite:draw{frame = v.animationFrame+1,priority = (config.foreground and -15) or -45,sceneCoords = true}

	npcutils.hideNPC(v)
end


-- Make podoboos transform to this NPC
NPC.config[12].yoshitonguetransform = npcID
NPC.config[589].yoshitonguetransform = npcID
NPC.config[590].yoshitonguetransform = npcID


return spitPodoboo