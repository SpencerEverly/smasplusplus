 local npcManager = require("npcManager")

local QuadCannon = {}
local npcID = NPC_ID

local QuadCannonSettings = {
	id = npcID,
	gfxheight = 96,
	gfxwidth = 64,
	width = 64,
	height = 96,
	gfxoffsetx = 0,
	gfxoffsety = 0,
	frames = 1,
	framestyle = 1,
	speed = 1,
	npcblock = true,
	npcblocktop = true,
	playerblock = true,
	playerblocktop = true,
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
	harmlessthrown = true
}

npcManager.setNpcSettings(QuadCannonSettings)
npcManager.registerDefines(npcID,{NPC.UNHITTABLE})

function QuadCannon.onInitAPI()
	npcManager.registerEvent(npcID, QuadCannon,"onTickNPC")
	npcManager.registerEvent(npcID, QuadCannon,"onDrawNPC")
end

function QuadCannon.onTickNPC(v)
	if Defines.levelFreeze then return end
	
	local data = v.data
	
	if v:mem(0x12A, FIELD_WORD) <= 0 then
		data.waitingframe = 0
		data.frame = 0
		return
	end

	if data.waitingframe == nil then
		data.waitingframe = 0
		data.frame = 0
	end

	if v:mem(0x12C, FIELD_WORD) > 0
	or v:mem(0x136, FIELD_BOOL)
	or v:mem(0x138, FIELD_WORD) > 0
	then
		data.waitingframe = 0
		data.frame = 0
	else
		data.waitingframe = data.waitingframe + 1
	end
	if data.waitingframe == 65 then
		if data.frame == 0 then
			v1 = NPC.spawn(765,v.x-16,v.y+48,player.section)
			v1.speedX = -3
			v1.speedY = 0
			v2 = NPC.spawn(765,v.x+48,v.y+48,player.section)
			v2.speedX = 3
			v2.speedY = 0
			v3 = NPC.spawn(765,v.x+16,v.y+16,player.section)
			v3.speedX = 0
			v3.speedY = -3
			v4 = NPC.spawn(765,v.x+16,v.y+80,player.section)
			v4.speedX = 0
			v4.speedY = 3
			if player2 then
				if player.section ~= player2.section then
					v1a = NPC.spawn(765,v.x-16,v.y+48,player2.section)
					v1a.speedX = -3
					v1a.speedY = 0
					v2a = NPC.spawn(765,v.x+48,v.y+48,player2.section)
					v2a.speedX = 3
					v2a.speedY = 0
					v3a = NPC.spawn(765,v.x+16,v.y+16,player2.section)
					v3a.speedX = 0
					v3a.speedY = -3
					v4a = NPC.spawn(765,v.x+16,v.y+80,player2.section)
					v4a.speedX = 0
					v4a.speedY = 3
				end
			end
			Animation.spawn(10,v.x-16,v.y+48)
			Animation.spawn(10,v.x+48,v.y+48)
			Animation.spawn(10,v.x+16,v.y+16)
			Animation.spawn(10,v.x+16,v.y+80)
		else
			v5 = NPC.spawn(765,v.x-8,v.y+24,player.section)
			v5.speedX = -3
			v5.speedY = -3
			v6 = NPC.spawn(765,v.x+40,v.y+24,player.section)
			v6.speedX = 3
			v6.speedY = -3
			v7 = NPC.spawn(765,v.x-8,v.y+72,player.section)
			v7.speedX = -3
			v7.speedY = 3
			v8 = NPC.spawn(765,v.x+40,v.y+72,player.section)
			v8.speedX = 3
			v8.speedY = 3
			Animation.spawn(10,v.x-8,v.y+24)
			Animation.spawn(10,v.x+40,v.y+24)
			Animation.spawn(10,v.x-8,v.y+72)
			Animation.spawn(10,v.x+40,v.y+72)
			if player2 then
				if player.section ~= player2.section then
					v5a = NPC.spawn(765,v.x-8,v.y+24,player2.section)
					v5a.speedX = -3
					v5a.speedY = -3
					v6a = NPC.spawn(765,v.x+40,v.y+24,player2.section)
					v6a.speedX = 3
					v6a.speedY = -3
					v7a = NPC.spawn(765,v.x-8,v.y+72,player2.section)
					v7a.speedX = -3
					v7a.speedY = 3
					v8a = NPC.spawn(765,v.x+40,v.y+72,player2.section)
					v8a.speedX = 3
					v8a.speedY = 3
				end
			end
		end
		SFX.play(22)
	end
	if data.waitingframe > 130 then
		if v.data.frame == 0 then
			data.frame = 1
		else
			data.frame = 0
		end
		data.waitingframe = 0
	end
	v.speedY = 0
end

function QuadCannon.onDrawNPC(v)
	local data = v.data
	data.frame = data.frame or 0
	v.animationFrame = data.frame
end

return QuadCannon