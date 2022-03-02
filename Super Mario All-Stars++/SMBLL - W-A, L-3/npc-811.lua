local npc = {}
local npcManager = require("npcManager")
local id = NPC_ID

npcManager.setNpcSettings{
	id = id,
	
	koopaId = id - 1,
	rotationSpeed = 0.45,
	
	nogravity = true,
	noblockcollision = true,
	nohurt = true,
	jumphurt = true,
}

local orbits = require 'orbits'

function npc.onTickEndNPC(v)
	local data = v.data._basegame
	local config = NPC.config[id]
	
	if not data.init then
		local settings = v.data._settings
		
		data.orbit = orbits.new{
			x = v.x + v.width / 2,
			y = v.y + v.height / 2 + 32,
			
			section = v.section,
			id = config.koopaId,
			number = settings.num,
			radius = settings.rad,
			
			rotationSpeed = config.rotationSpeed,
		}
		
		data.init = true
	end
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end


return npc