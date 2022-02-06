local npc = {}
local npcManager = require("npcManager")
local id = NPC_ID

local defaultSettings = {
	id = id,
	
	gfxheight = 64,
	height = 64,
	width = 32,
	gfxwidth = 32,
	
	frames = 2,
	
	nogravity = true,
	noblockcollision = true,
	
	jumphurt = true,
	nohurt = true,
	
	noiceball = true,
	noyoshi = true,
	
	speedY = 16
}

function npc.onTickEndNPC(v)
	local config = NPC.config[v.id]
	
	for k,p in ipairs(Player.getIntersecting(v.x, (v.y + v.height / 2) - 1, v.x + v.width, v.y + v.height)) do
		if p.y < v.y + v.height / 2 and p.speedY > 0 then
			SFX.play(24)
			
			p.y = (v.y + v.height / 2) - p.height
			p:mem(0x11C, FIELD_WORD, -1)
			p.speedY = -config.speedY
			
			v.ai1 = v.ai1 + 1
		end
	end
	
	if v.ai1 > 0 then
		v.ai1 = v.ai1 + 0.25
		
		if v.ai1 > config.frames then
			v.ai1 = 0
		end	
	end
	
	v.animationFrame = math.floor(v.ai1)
end

function npc.register(config)
	local config = table.join(config, defaultSettings)
	npcManager.setNpcSettings(config)

	npcManager.registerEvent(config.id, npc, "onTickEndNPC")
end

return npc