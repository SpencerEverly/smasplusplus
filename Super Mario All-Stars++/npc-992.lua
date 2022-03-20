local npc = {}
local id = NPC_ID
local yoshis = require 'yoshis'

local yoshi = {
	id = 11,
	npcId = id,
	
	name = 'BROWN',
}

yoshi.onInputUpdate = function(v)
	-- if not v:isOnGround() and v.keys.down == KEYS_UP then
		-- v:mem(0x60, FIELD_BOOL, true)
	if not v:isOnGround() and v.keys.down == KEYS_DOWN then
		v:mem(0x5C, FIELD_BOOL, true)
	end
end

local turnIntoVegetable = {
	[195] = true,
	[194] = true,
	[115] = true,
	[111] = true,
}

yoshi.onTickEnd = function(v)
	local idx = v:mem(0xB8,FIELD_WORD)
	if idx > 0 then
		local n = NPC(idx - 1)
		local cfg = NPC.config[n.id]
		
		if turnIntoVegetable[n.id] then
			local t = {
				144,92,141,
				139,140,142,
				145,143,146,
			}
			
			Effect.spawn(10, n.x, n.y)
			n.id = t[math.random(1, #t)]
		end
		
		v:mem(0x64, FIELD_BOOL, true)
		v:mem(0x68,	FIELD_BOOL, true)
	end
end

yoshis.registerColor(yoshi)

yoshis.register{
	id = id,
	
	color = 11,
}

return npc