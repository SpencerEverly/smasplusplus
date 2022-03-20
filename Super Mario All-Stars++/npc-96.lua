local npc = {}
local id = NPC_ID

function npc.onTickEndNPC(v)
	local npc = v.ai1
	
	if npc == 824 then
		v.animationFrame = 8
	elseif npc == 826 then
		v.animationFrame = 9
	elseif npc == 827 then
		v.animationFrame = 10
	end
end

local effects = {
	[824] = 775,
	[826] = 776,
	[827] = 777,
	
	[828] = 775,
	[829] = 776,
	[830] = 777,
}

local baby = {
	[828] = true,
	[829] = true,
	[829] = true,
}

function npc.onPostNPCKill(v, r)
	if v.id ~= id then return end
	
	if r == 1 and effects[v.ai1] then
		local e = Effect.spawn(effects[v.ai1], v.x, v.y)
		e.npcID = v.ai1
		
		v:kill(9)
	end
end

function npc.onStart()
	local effects2 = {
		775,
		776,
		777,
	}

	for k,i in ipairs(effects2) do
		local e = Effect.config[i][1]
		e.onDeath = function(v)
			Effect.spawn(57, v.x + 8, v.y + 8)
			
			if v.npcID ~= 0 then
				if not baby[v.npcID] then
					SFX.play(48)
					
					local y = Effect.spawn(i + 3, v.x, v.y)
					y.npcID = v.npcID
				else
					NPC.spawn(v.npcID, v.x, v.y)
				end
			end
		end
		
		local e2 = Effect.config[i + 3][1]
		e2.onDeath = function(v)
			if v.npcID <= 0 then return end
			
			local y = NPC.spawn(v.npcID, v.x, v.y)
			y.direction = 1
		end
	end
end

function npc.onInitAPI()
	local npcManager = require 'npcManager'
	
	registerEvent(npc, 'onPostNPCKill')
	registerEvent(npc, 'onStart')
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc 