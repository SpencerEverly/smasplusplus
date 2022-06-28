local npcManager = require("npcManager")

local DownSideCannon = {}
local npcID = NPC_ID

local DownSideCannonSettings = {
	id = npcID,
	gfxheight = 64,
	gfxwidth = 64,
	width = 64,
	height = 64,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 1,
	framestyle = 1,
	speed = 1,
	npcblock = false,
	npcblocktop = false,
	playerblock = false,
	playerblocktop = false,
	nohurt=true,
	nogravity = true,
	noblockcollision = false,
	nofireball = false,
	noiceball = false,
	noyoshi = true,
	nowaterphysics = true,
	jumphurt = true,
	spinjumpsafe = false,
	harmlessgrab = false,
	harmlessthrown = true,
	shootrate = 195
}

npcManager.setNpcSettings(DownSideCannonSettings)
npcManager.registerDefines(npcID,{NPC.UNHITTABLE})

function DownSideCannon.onInitAPI()
	npcManager.registerEvent(npcID, DownSideCannon,"onTickNPC")
end

function DownSideCannon.onTickNPC(v)
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
		v1 = NPC.spawn(765,v.x+16+((NPC.config[npcID].width-32)/2)*v.direction,v.y+NPC.config[npcID].height/2,player.section)
		v1.direction = v.direction
		v1.speedX = 3*v.direction
		v1.speedY = 3
		if player2 then
			if player.section ~= player2.section then
				v2 = NPC.spawn(765,v.x+16+((NPC.config[npcID].width-32)/2)*v.direction,v.y+NPC.config[npcID].height/2,player2.section)
				v2.direction = v.direction
				v2.speedX = 3*v.direction
				v2.speedY = 3
			end
		end
		Animation.spawn(10,v.x+16+((NPC.config[npcID].width-32)/2)*v.direction,v.y+NPC.config[npcID].height/2)
		SFX.play(22)
		data.waitingframe = 0
	end
	v.speedY = 0
end

return DownSideCannon