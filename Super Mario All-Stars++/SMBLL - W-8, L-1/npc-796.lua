local npc = {}
local npcManager = require("npcManager")
local id = NPC_ID

npcManager.setNpcSettings({
	id = id,
	
	width = 64,
	height = 72,
	gfxoffsety = 2,
	jumphurt = true,
	
	noyoshi = true,
	noiceball = true,

	fireId = 87
})

local function animation(v)
	local data = v.data._basegame
	
	data.frame = 0
	
	if v.ai1 == 0 then
		data.frametimer = data.frametimer + 1
		
		if data.frametimer <= 8 then
			data.frame = 1
		elseif data.frametimer <= 16 then
			data.frame = 0
		elseif data.frametimer <= 24 then
			data.frame = 2
		elseif data.frametimer <= 32 then
			data.frame = 0
		else
			data.frametimer = 0
		end
	elseif v.ai1 == 1 then
		data.frametimer = 0
		data.frame = 3
	elseif v.ai1 == 2 then
		data.frametimer = 0
		data.frame = 4
	end
	
	if v.direction == 1 then
		data.frame = data.frame + 5
	end
end

function npc.onTickEndNPC(v)
	local config = NPC.config[id]
	local data = v.data._basegame
	
	data.frametimer = data.frametimer or 0
	data.hp = data.hp or 12
	
	local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
	
	if p.x + p.width / 2 > v.x + 16 then
		v.direction = 1
	else
		v.direction = -1
	end
	
	if math.random(300) > 297 and v.ai1 == 0 then
		v.ai1 = 1
	end
	
	if v.ai1 > 0 then
		v.ai3 = v.ai3 + 1
		
		if v.ai3 < 40 then
			v.ai1 = 1
		elseif v.ai3 < 70 then
			if v.ai3 == 40 then
				local fire = NPC.spawn(config.fireId, v.x, v.y + 19)
				fire.despawnTimer = 100
				fire.direction = v.direction
				
				if v.direction == 1 then
					fire.x = fire.x + 54
					fire.animationFrame = 4
				else
					fire.x = fire.x - 40
				end
				
				fire.layerName = "Spawned NPCs"
				fire.speedX = 4 * fire.direction
				
				C = (fire.x + fire.width / 2) - (p.x + p.width / 2)
				D = (fire.y + fire.height / 2) - (p.y + p.height / 2)
				
				fire.speedY = D / C * fire.speedX
				fire.speedY = math.clamp(fire.speedY, -1, 1)
				
				SFX.play(42)
			end
			
			v.ai1 = 2
		else
			v.ai1 = 0
			v.ai3 = 0
		end
	end
	
	if v.ai2 == 0 then
		v.speedX = -0.5
		if v.x < v.spawnX - v.width * 1.5 then
			v.ai2 = 1
		end
	else
		v.speedX = 0.5
		if v.x > v.spawnX + v.width * 1.5 then
			v.ai2 = 0
		end
	end
	
	if v.collidesBlockBottom then
		if math.random(200) >= 198 then
			v.speedY = -8
		end
	end

	animation(v)
	v.animationFrame = data.frame
	
	if v.ai5 > 0 then
		v.ai5 = v.ai5 - 1
	end
end

function npc.onNPCHarm(e, v, r, c)
	if v.id ~= id then return end
	
	local data = v.data._basegame
	
	local cancelled = true
	
	if v.ai5 <= 0 then
		if r == 3 then
			v.ai5 = 20
			
			if c then
				if c.id ~= 13 then
					SFX.play(39)
					data.hp = data.hp - 3
				else
					SFX.play(9)
					data.hp = data.hp - 1
				end
			end
		elseif r == 10 then
			SFX.play(39)
			v.ai5 = 20
			data.hp = data.hp - 1
		end
	end
	
	if r == 6 then
		cancelled = false
	end
	
	if data.hp <= 0 then
		cancelled = false
	end
	
	e.cancelled = cancelled
end

function npc.onInitAPI()
	npcManager.registerEvent(id, npc, 'onTickEndNPC')
	npcManager.registerHarmTypes(id,
		{
			3,
			10,
			6
		}, 
		{
			[HARM_TYPE_NPC] = 53,
			[HARM_TYPE_SWORD] = 53,
			[HARM_TYPE_LAVA]=10,
		}
	);
	
	registerEvent(npc, 'onNPCHarm')
end


return npc