local beezos = {}
local npcManager = require("npcManager")

local idList  = {}

local defaultSettings = {
	frames=2,
	framestyle=2,
	framespeed=4,
	
	playerblocktop = true,
	npcblocktop = true,
	grabtop = true,
	
	noblockcollision = true,
	nogravity = true,
	
	effect = 757,
	canDive = true,
	vertical_speed = 4,
}

function beezos.register(config)
    table.insert(idList, config.id)
	local config = table.join(config, defaultSettings)
	npcManager.setNpcSettings(config)
	
	local t = {2, 3, 4, 5, 10, HARM_TYPE_LAVA, 7}
	local effects = {}
	
	for i = 1, #t do
		local v = t[i]
		
		if v ~= 6 then
			effects[v] = config.effect
		else
			effects[v] = {id=13, xoffset=0.5, xoffsetBack = 0, yoffset=1, yoffsetBack = 1.5}
		end
	end
	
	npcManager.registerHarmTypes(config.id, t, effects)
	
	npcManager.registerEvent(config.id, beezos, "onTickEndNPC")
end

function beezos.onTickEndNPC(v)
	if Defines.levelFreeze or v.despawnTimer <= 0 then return end
	
	local config = NPC.config[v.id]
	
	v.speedX = 4 * v.direction
	
	if v.ai1 == 0 then
		local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
		
		if (v.y + v.height / 2) > p.y + p.height / 2 then
			v.speedY = -config.vertical_speed
		else
			v.speedY = config.vertical_speed		
		end
		
		if config.canDive then
			v.ai1 = 1
		else
			v.ai1 = 2
		end
	elseif v.ai1 == 1 then
		local p = Player.getNearest(v.x + v.width / 2, v.y + v.height / 2)
		
		if v.speedY > 0 then
			if (v.y + v.height / 2) > p.y - (v.height / 2 - 4) then
				v.ai1 = 2
			end
		else
			if (v.y + v.height / 2) < p.y + p.height + v.height / 2 then
				v.ai1 = 2
			end
		end
	else
		if v.speedY > 0 then
			v.speedY = v.speedY - 0.1
		else
			v.speedY = v.speedY + 0.1
		end
		
		v.speedY = v.speedY * 0.9
	end
	
	if v:mem(0x132, FIELD_WORD) > 0 then
		v:kill(2)
	end
end

return beezos