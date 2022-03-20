local npc = {}
local id = NPC_ID
local yoshis = require 'yoshis'

local yoshi = {
	id = 10,
	npcId = id,
	
	name = 'WHITE',
}

yoshi.onInputUpdate = function(v)
	local ready = v:mem(0x24, FIELD_WORD)
	local keys = v.keys
	
	if keys.jump == KEYS_RELEASED then
		if ready == 0 then
			v:mem(0x24, FIELD_WORD, ready + 1)
		end
	elseif keys.jump == KEYS_PRESSED then
		if ready == 1 then
			v.speedY = -6
			v:mem(0x11C, FIELD_WORD, 20)
			
			for i = -1,1 do
				local x = 16 * i
				
				Effect.spawn(10, v.x + x, v.y + v.height - 16)
			end
			
			for x = 0, v.width, 16 do
				for y = 0, v.height, 16 do
					if math.random() > 0.5 then
						Effect.spawn(80, v.x + x, v.y + y)
					end
				end
			end
			
			v:mem(0x24, FIELD_WORD, ready + 1)
		end
	end
end

yoshi.onTickEnd = function(v)
	if v:isOnGround() then
		v:mem(0x24, FIELD_WORD, 0)
	end
	
	v:mem(0x00, FIELD_BOOL, true)
end

yoshis.registerColor(yoshi)

yoshis.register{
	id = id,
	
	color = 10,
}

return npc