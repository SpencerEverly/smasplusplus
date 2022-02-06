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
	
	cliffturn = true,
	
	transform = id + 1,
	effect = 771,
}


function npc.onTickEndNPC(v)
	-- local config = NPC.config[id]

	if Defines.levelFreeze then return end
	
	if v:mem(0x12C, FIELD_WORD) > 0    --Grabbed
	or v:mem(0x136, FIELD_BOOL)        --Thrown
	or v:mem(0x138, FIELD_WORD) > 0    --Contained within
	then
		return
	end
	
	v.speedX = 1.2 * v.direction
end

function npc.onPostNPCHarm(v, r, c)
	if v.id ~= id then return end

	local config = NPC.config[id]
	
	if r == 1 or r == 7 or r == 2 then
		local shell = NPC.spawn(config.transform, v.x, v.y)
		shell.layerName = "Spawned NPCs"
		shell.y = shell.y + (v.height - shell.height) / 2
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
			4,
			6,
			10,
		}, 
		{			
			[3] = config.effect,
			[4] = config.effect,	
			[HARM_TYPE_LAVA]=10,
		}
	);
	
	registerEvent(npc, 'onPostNPCHarm')
end


return npc