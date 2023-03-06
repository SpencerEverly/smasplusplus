local npc = {}
local npcManager = require("npcManager")
local extrasounds = require("extrasounds")

local id = NPC_ID

npcManager.setNpcSettings({
	id = id,
	
	width = 64,
	gfxwidth = 64,
	gfxheight = 32,
	height = 32,
	
	frames = 4,
	framespeed = 4,
	
	jumphurt = true,
	nohurt = true,
	
	noyoshi = true,
	noiceball = true,
	
	nogravity = true,
	noblockcollision = true,
	
	boltBGO = 251,
    boltBGO2 = 998,
})

function npc.onTickEndNPC(v)
	local config = NPC.config[id]
	local count = 0
	
	for k,p in ipairs(Player.getIntersecting(v.x, v.y, v.x + v.width, v.y + v.height)) do
		p.speedY = 1

		if (p.keys.jump or p.keys.altJump) and p.speedY > 0 and p:mem(0x11C, FIELD_WORD) <= 0 then
			SFX.play((p:mem(0x50, FIELD_BOOL) and extrasounds.sound.sfx[33]) or extrasounds.sound.sfx[1])
			
			p:mem(0x11C, FIELD_WORD, 20)
			p.speedY = -6
		end
		
		count = 1
		
		v.ai1 = 1
	end
	
	if count == 0 then
		v.animationTimer = 0
		
		if v.speedX > 0 then
			v.speedX = v.speedX - 0.1
		else
			v.speedX = v.speedX + 0.1
		end
		
		if v.speedX >= -0.1 and v.speedX <= 0.1 then
			v.speedX = 0
		end
	else
		v.speedX = 2 * v.direction
	end
	
	if v.ai1 == 1 then
		local fall = true
		
		for k,b in BGO.iterateIntersecting(v.x, v.y, v.x + v.width, v.y + v.height) do
			if b.id == config.boltBGO or b.id == config.boltBGO2 and v.y > b.y then
				fall = false
				v.y = b.y
			end
		end
		
		if fall then
			v.speedY = v.speedY + 0.3
		else
			v.speedY = 0
		end
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc