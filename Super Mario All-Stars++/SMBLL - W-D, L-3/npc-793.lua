local npc = {}
local npcManager = require("npcManager")
local id = NPC_ID

npcManager.setNpcSettings({
	id = id,
	
	gfxheight = 16,
	height = 16,
	width = 64,
	gfxwidth = 64,
	
	frames = 1,
	
	nogravity = true,
	noblockcollision = true,
	
	jumphurt = true,
	nohurt = true,
	
	noiceball = true,
	noyoshi = true,
	
	playerblocktop = true,
	npcblocktop = true,
})

function npc.onTickEndNPC(v)
	if v.ai1 == 2 then
		v.speedY = v.speedY + 0.3
	elseif v.ai1 == 0 then
		v.speedY = 3 * v.direction
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end


return npc