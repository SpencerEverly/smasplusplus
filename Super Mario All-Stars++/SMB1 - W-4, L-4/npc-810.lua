local npc = {}
local npcManager = require("npcManager")
local id = NPC_ID

npcManager.setNpcSettings{
	id = id,
	
	width = 32,
	gfxwidth = 32,
	gfxheight = 48,
	height = 32,
	
	frames = 2,
	framestyle = 1,
	
	nogravity = true,
	noblockcollision = true,
	
	transform = id - 2,
	effect = 771,
}

function npc.onPostNPCHarm(v, r, c)
	if v.id ~= id then return end

	local config = NPC.config[id]
	
	if r == 1 then
		local shell = NPC.spawn(config.transform, v.x, v.y)
		shell.layerName = "Spawned NPCs"
		shell.y = shell.y + (v.height - shell.height) / 2
		shell.direction = v.direction
	end
end

function npc.onInitAPI()
	local config = NPC.config[id]
	
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
	npcManager.registerHarmTypes(id,
		{
			HARM_TYPE_SPINJUMP,
			1,
			2,
			7,
			3,
			6,
			10,
		}, 
		{
			[HARM_TYPE_LAVA]=10,
			[3] = config.effect,
		}
	);
	
	registerEvent(npc, 'onPostNPCHarm')
end


return npc