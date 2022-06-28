local npcManager = require("npcManager")

local LargeCannonPipe = {}
local npcID = NPC_ID

local LargeCannonPipeSettings = {
	id = npcID,
	gfxheight = 64,
	gfxwidth = 32,
	width = 32,
	height = 64,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 1,
	framestyle = 1,
	speed = 0,
	npcblock = true,
	npcblocktop = true,
	playerblock = true,
	playerblocktop = true,
	nohurt=true,
	nogravity = true,
	noblockcollision = true,
	nofireball = false,
	noiceball = false,
	noyoshi = true,
	nowaterphysics = true,
	--Various interactions
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = true,
	shootrate = 195
}

npcManager.setNpcSettings(LargeCannonPipeSettings)
npcManager.registerDefines(npcID,{NPC.UNHITTABLE})

function LargeCannonPipe.onInitAPI()
	npcManager.registerEvent(npcID, LargeCannonPipe,"onTickNPC")
end

function LargeCannonPipe.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		data.waitingframe = 0
		return
	end

	if data.waitingframe == nil then
		data.waitingframe = 0
	end

	if v:mem(0x12C, FIELD_WORD) > 0
	or v:mem(0x136, FIELD_BOOL)
	or v:mem(0x138, FIELD_WORD) > 0
	then
		data.waitingframe = 0
	else
		data.waitingframe = data.waitingframe + 1
	end
	if data.waitingframe > NPC.config[npcID].shootrate then
		v1 = NPC.spawn(772,v.x+(NPC.config[npcID].width*v.direction),v.y+8,player.section)
		v1.direction = v.direction
		v1.speedX = 5*v.direction
		if player2 then
			if player.section ~= player2.section then
				v2 = NPC.spawn(772,v.x+(NPC.config[npcID].width*v.direction),v.y+8,player2.section)
				v2.direction = v.direction
				v2.speedX = 5*v.direction
			end
		end
		Animation.spawn(10,v.x+(NPC.config[npcID].width*v.direction)/2,v.y+16)
		SFX.play(22)
		data.waitingframe = 0
	end
	v.speedY = 0
end

return LargeCannonPipe