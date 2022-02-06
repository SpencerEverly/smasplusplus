local npcManager = require("npcManager")

local TouchFallPlat = {}
local npcID = NPC_ID

local TouchFallPlatSettings = {
	id = npcID,
	gfxheight = 32,
	gfxwidth = 96,
	width = 96,
	height = 32,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 1,
	framestyle = 0,
	framespeed = 8,
	speed = 1,
	npcblock = false,
	npcblocktop = true,
	playerblock = false,
	playerblocktop = true,
	nohurt=true,
	nogravity = true,
	noblockcollision = true,
	nofireball = false,
	noiceball = true,
	noyoshi= true,
	nowaterphysics = true,
	jumphurt = false,
	spinjumpsafe = false,
	harmlessgrab = true,
	harmlessthrown = true
}

npcManager.setNpcSettings(TouchFallPlatSettings)
npcManager.registerDefines(npcID, {NPC.UNHITTABLE})


function TouchFallPlat.onInitAPI()
	npcManager.registerEvent(npcID, TouchFallPlat, "onTickNPC")
end

function TouchFallPlat.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	data.stomped = data.stomped or false
	data.fallspeed = data.fallspeed or 0

	if v:mem(0x12A, FIELD_WORD) <= 0 then
		data.stomped = false
		data.fallspeed = 0
		return
	end

	if v:mem(0x12C, FIELD_WORD) > 0
	or v:mem(0x136, FIELD_BOOL)
	or v:mem(0x138, FIELD_WORD) > 0
	then

	end
	for _,p in ipairs(Player.get()) do
		if (p.standingNPC ~= nil and p.standingNPC.idx == v.idx) then
			data.stomped = true
			break
		end
	end
	if not data.stomped then
		v.speedX = NPC.config[npcID].speed*v.direction
		v.speedY = 0
	else
		v.speedX = 0
		if data.fallspeed < 8 then
			data.fallspeed = data.fallspeed + Defines.npc_grav
		end
		v.speedY = data.fallspeed
	end
end

return TouchFallPlat