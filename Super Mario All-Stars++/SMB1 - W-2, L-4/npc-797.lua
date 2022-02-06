local npc = {}
local npcManager = require("npcManager")

local id = NPC_ID

npcManager.setNpcSettings({
	id = id,
	
	jumphurt = true,
	nohurt = true,
	
	noyoshi = true,
	noiceball = true,
	
	effect = 768,
})

local sfx =  SFX.play("wind.ogg", 1, 0)

function npc.onTickEnd()
	local play = false
	
	for k,v in NPC.iterate(id) do
		if v.isValid and v.despawnTimer > 100 then
			play = true
		end
	end
	
	if play then
		sfx:resume()
	else
		sfx:pause()
	end
end

function npc.onTickEndNPC(v)
	if v.despawnTimer < 100 then
		return 
	end
	
	v.friendly = true
	
	local config = NPC.config[id]
	local section = Section(v.section)
	
	if math.random() > 0.5 then
		local x = section.boundary.left
		
		if v.direction == -1 then
			x = section.boundary.right
		end
		
		local e = Effect.spawn(config.effect, x, section.boundary.top)
		e.y = e.y + (math.random(0, section.boundary.bottom - section.boundary.top))
		e.speedX = 48 * v.direction
	end
	
	for k,p in ipairs(Player.get()) do
		if p.section == v.section then
			if v.direction == -1 then
				p.speedX = math.clamp(p.speedX, -6, 2)
				
				if not p.keys.right then
					p:mem(0x138, FIELD_FLOAT, 0.25 * v.direction)
				end
			else
				p.speedX = math.clamp(p.speedX, -2, 6)
			
				if not p.keys.left then
					p:mem(0x138, FIELD_FLOAT, 0.25 * v.direction)
				end
			end
		end
	end
end

function npc.onInitAPI()
	registerEvent(npc, 'onTickEnd')
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
end

return npc