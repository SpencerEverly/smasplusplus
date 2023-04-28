local npc = {}
local npcManager = require("npcManager")
local rebounder = require("npcs/ai/rebounder");

local id = NPC_ID

npcManager.setNpcSettings{
	id = id,
	
	gfxwidth = 32,
	gfxheight = 32,
	width = 32,
	height = 32,
	frames=2,
	nogravity = true,
	
	jumphurt = true,
	noyoshi = true,
	spinjumpsafe = true,
}

rebounder.register(id)

function npc.onTickEndNPC(v)
    if Defines.levelFreeze then return end
    
	if math.random() > 0.75 then
		Effect.spawn(770, v.x + math.random(-8, v.width), v.y + math.random(-8, v.height))
	end
	
	v.ai1 = v.ai1 + 1
	
	if v.ai1 > 500 then
		Effect.spawn(10, v.x, v.y)
		v:kill(9)
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc